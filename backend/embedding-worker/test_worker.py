import unittest
from types import SimpleNamespace
from unittest.mock import Mock, patch

import worker
from worker import course_text, preference_text


class HuggingFaceModelTests(unittest.TestCase):
    def test_loads_configured_model_with_sentence_transformers(self):
        transformer = Mock()
        with patch.object(worker, "_model", None), patch.dict(
            "sys.modules", {"sentence_transformers": SimpleNamespace(SentenceTransformer=transformer)}
        ):
            self.assertIs(worker.get_model(), transformer.return_value)
            self.assertIs(worker.get_model(), transformer.return_value)
        transformer.assert_called_once_with(worker.MODEL, revision=worker.REVISION, device=worker.DEVICE)

    def test_course_and_query_use_same_model_with_query_instruction(self):
        model = Mock()
        model.encode.return_value.tolist.return_value = [0.6, 0.8]
        with patch.object(worker, "get_model", return_value=model):
            self.assertEqual(worker.embed("Curso"), [0.6, 0.8])
            self.assertEqual(worker.embed("Objetivo", is_query=True), [0.6, 0.8])
        self.assertEqual(model.encode.call_args_list[0].kwargs,
                         {"normalize_embeddings": True, "show_progress_bar": False})
        self.assertEqual(model.encode.call_args_list[1].kwargs["prompt"],
                         f"Instruct: {worker.QUERY_INSTRUCTION}\nQuery: ")

    def test_database_url_missing_raises_clear_error(self):
        with patch.dict("os.environ", {}, clear=True):
            with self.assertRaisesRegex(ValueError, "DATABASE_URL"):
                worker.get_database_connection_string()


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
