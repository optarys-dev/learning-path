export const areas = {
  frontend: ['react', 'angular', 'vue', 'nuxt', 'nextjs', 'astro', 'qwik', 'tailwind', 'shadcn-ui'],
  backend: ['node', 'nestjs', 'dotnet-csharp', 'java-spring', 'python', 'django', 'fastapi', 'go', 'php', 'laravel'],
  ai: ['prompts', 'agents', 'rag', 'openai', 'claude', 'gemini', 'ai-assisted-development'],
  mobile: ['flutter', 'dart', 'react-native', 'expo', 'bloc', 'riverpod'],
  data: ['sql', 'postgresql'],
  automation: ['n8n', 'mcp', 'python'],
  foundations: ['programming', 'git', 'github', 'docker', 'vs-code', 'solid', 'design-patterns'],
} as const;

export const levels = ['none', 'basics', 'small-projects', 'complete-applications'] as const;
export const desiredOutcomes = ['build-api', 'build-web-app', 'build-mobile-app', 'applied-ai', 'build-automations', 'work-with-databases'] as const;
export const practicalExperiences = ['none', 'exercises', 'personal-projects', 'complete-applications'] as const;

export const questions = [
  { id: 'learningGoal', answer: 'goal', selection: 'area-with-interests', required: true },
  { id: 'currentExperience', answer: 'level', selection: 'single', required: true },
  { id: 'knownSkills', answer: 'knownSkills', selection: 'multiple-by-area', required: false },
  { id: 'desiredOutcome', answer: 'desiredOutcome', selection: 'single', required: true },
  { id: 'practicalExperience', answer: 'experience', selection: 'single', required: true },
] as const;
