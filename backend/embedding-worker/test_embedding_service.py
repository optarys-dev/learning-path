import unittest
from types import SimpleNamespace
from unittest.mock import Mock, patch

from fastapi.testclient import TestClient

import api
import embedding_service as embedding_module
import worker
from embedding_service import EmbeddingService, course_text, preference_text


class HuggingFaceModelTests(unittest.TestCase):
    def test_loads_configured_model_with_sentence_transformers(self):
        transformer = Mock()
        service = EmbeddingService()
        with patch.dict(
            "sys.modules", {"sentence_transformers": SimpleNamespace(SentenceTransformer=transformer)}
        ):
            self.assertIs(service.load_model(), transformer.return_value)
            self.assertIs(service.load_model(), transformer.return_value)
        transformer.assert_called_once_with(embedding_module.MODEL,
                                            revision=embedding_module.REVISION,
                                            device=embedding_module.DEVICE)

    def test_course_and_query_use_same_model_with_query_instruction(self):
        model = Mock()
        model.encode.return_value.tolist.return_value = [0.6, 0.8]
        service = EmbeddingService()
        service._model = model
        self.assertEqual(service.embed("Curso"), [0.6, 0.8])
        self.assertEqual(service.embed("Objetivo", is_query=True), [0.6, 0.8])
        self.assertEqual(model.encode.call_args_list[0].kwargs,
                         {"normalize_embeddings": True, "show_progress_bar": False})
        self.assertEqual(model.encode.call_args_list[1].kwargs["prompt"],
                         f"Instruct: {embedding_module.QUERY_INSTRUCTION}\nQuery: ")

    def test_service_builds_preference_embedding_without_existing_skills(self):
        service = EmbeddingService()
        with patch.object(service, "embed", return_value=[0.6, 0.8]) as embed:
            result = service.embed_preferences({
                "goal": "Aprender Python", "interests": ["Backend"],
                "existingSkills": ["React"]
            })
        self.assertEqual({"model": service.model_id, "dimensions": 2,
                          "embedding": [0.6, 0.8]}, result)
        embed.assert_called_once_with(
            "Objetivo: Aprender Python\nIntereses: Backend", is_query=True)

    def test_database_url_missing_raises_clear_error(self):
        with patch.dict("os.environ", {}, clear=True):
            with self.assertRaisesRegex(ValueError, "DATABASE_URL"):
                worker.get_database_connection_string()


class ApiTests(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(api.app)

    def tearDown(self):
        self.client.close()

    def test_embeds_preferences_with_existing_response_contract(self):
        result = {"model": api.embedding_service.model_id,
                  "dimensions": 2, "embedding": [0.6, 0.8]}
        with patch.object(api.embedding_service, "embed_preferences", return_value=result) as embed:
            response = self.client.post("/embed-preferences", json={
                "goal": " Aprender Python ", "interests": ["Backend"],
                "experienceLevel": "Principiante", "existingSkills": ["React"]
            })

        self.assertEqual(200, response.status_code)
        self.assertEqual(result, response.json())
        embed.assert_called_once_with({
            "goal": "Aprender Python", "interests": ["Backend"],
            "experienceLevel": "Principiante"})

    def test_invalid_payload_returns_bad_request(self):
        response = self.client.post("/embed-preferences", json={"goal": "   "})
        self.assertEqual(400, response.status_code)
        self.assertEqual({"error": "invalid_request"}, response.json())

    def test_streamed_json_without_content_length_is_accepted(self):
        with patch.object(api.embedding_service, "embed_preferences", return_value={
            "model": api.embedding_service.model_id, "dimensions": 2,
            "embedding": [0.6, 0.8]}):
            response = self.client.post("/embed-preferences",
                content=iter([b'{"goal":"Aprender ', b'Python"}']),
                headers={"Content-Type": "application/json"})
        self.assertEqual(200, response.status_code)

    def test_model_value_error_returns_service_unavailable(self):
        with patch.object(api.embedding_service, "embed_preferences", side_effect=ValueError("model error")), \
                patch.object(api.logger, "exception") as log_error:
            response = self.client.post("/embed-preferences", json={"goal": "Aprender Python"})
        self.assertEqual(503, response.status_code)
        self.assertEqual({"error": "embedding_provider_unavailable"}, response.json())
        log_error.assert_called_once()

    def test_lifespan_preloads_model_before_health_is_ready(self):
        with patch.object(api.embedding_service, "load_model") as load_model:
            with TestClient(api.app) as client:
                response = client.get("/health")
                self.assertEqual({"status": "ok", "model": api.embedding_service.model_id}, response.json())
        load_model.assert_called_once_with()


class TextBuilderTests(unittest.TestCase):
    def test_public_metadata_and_stable_labels(self):
        course = {
            "title": "Python", "level": "Principiante",
            "categories": ["Fundamentos"], "tags": ["Python", "Backend"],
            "metadata_origin": "public-page-scrape-v1",
            "metadata_source_url": "https://example.test", "metadata_verified_at": None,
            "description": "Aprende Python", "syllabus": "Funciones",
            "learning_outcomes": [], "skills_taught": [],
            "prerequisites": ["Ninguno"], "target_audience": []
        }
        text = course_text(course)
        self.assertIn("Etiquetas: Backend, Python", text)
        self.assertIn("Descripción: Aprende Python", text)
        self.assertNotIn("https://", text)

    def test_synthetic_metadata_is_excluded(self):
        course = {
            "title": "Python", "level": None, "categories": [], "tags": [],
            "metadata_origin": "inferred-seed-v1", "metadata_source_url": None,
            "metadata_verified_at": None, "description": "Inventado",
            "syllabus": None, "learning_outcomes": [], "skills_taught": [],
            "prerequisites": [], "target_audience": []
        }
        self.assertEqual("Título: Python", course_text(course))

    def test_preference_query_does_not_promote_existing_skills(self):
        text = preference_text({"goal": "Aprender backend", "interests": ["Python"],
                                "experienceLevel": "Principiante", "existingSkills": ["React"]})
        self.assertIn("Intereses: Python", text)
        self.assertNotIn("React", text)


if __name__ == "__main__":
    unittest.main()
