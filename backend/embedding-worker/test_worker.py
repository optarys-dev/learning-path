import unittest

from worker import course_text, preference_text


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
