import type { landingEs } from './landing.es';

type Translate<T> = { [K in keyof T]: T[K] extends string ? string : Translate<T[K]> };

export const landingEn = {
  navigation: 'Explore CODE QUEST', howLink: 'How it works', insideLink: 'Your experience', faqLink: 'Questions',
  heroDescription: 'Turn what you want to learn into <strong>a path with direction</strong>. Your experience and interests help us organize <strong>real DevTalles courses</strong> around your next goal.',
  discover: 'Discover how it works', heroDetail: 'A path based on what you know and what you want to achieve.',
  createRoute: 'Create my path',
  promiseTitle: 'Learning is a journey. <accent>Choose your direction.</accent>',
  promises: {
    goal: { title: 'Your goal comes first', text: 'A starting point based on what you want to learn.' },
    catalog: { title: 'Real courses', text: 'Recommendations based on the DevTalles catalog.' },
    pace: { title: 'At your own pace', text: 'A path you can return to, step by step.' },
  },
  how: {
    eyebrow: 'FROM “WHERE DO I START?” TO YOUR NEXT STEP', title: 'A clear path. <accent>Made for you.</accent>',
    description: 'Here is the journey from your first answer to your next learning milestone.',
    label: 'Explore the stages of your journey', preview: 'How it works · Conceptual preview', resultLabel: 'What you get',
    personalize: { tab: 'Your starting point', title: 'First, we get to know you.', description: 'Tell us your goal, your experience and what you already know. We can then find a starting point that makes sense for you.', itemOne: 'Your learning goal', itemTwo: 'Your experience and existing skills', itemThree: 'Your areas and technologies of interest', outcome: 'A foundation for better recommendations' },
    discover: { tab: 'Your path', title: 'Then, we connect the steps.', description: 'Get a sequence of courses from the catalog, with the foundations you need to move toward your goal.', itemOne: 'Real DevTalles courses', itemTwo: 'A logical learning order', itemThree: 'Prerequisites to help you move forward', outcome: 'Clarity on what to learn next' },
    progress: { tab: 'Your progress', title: 'Keep going at your own pace.', description: 'Save your path, explore each course and mark your progress. Your paths stay within reach whenever you want to return.', itemOne: 'Your saved path', itemTwo: 'Progress that you record yourself', itemThree: 'Your next steps within reach', outcome: 'A journey you can return to' },
  },
  experience: {
    eyebrow: 'MORE THAN A LIST OF COURSES', title: 'From having options to <accent>having a plan.</accent>',
    description: 'CODE QUEST helps you organize your learning. You choose the goal; your path helps you see the next step.',
    direction: { title: 'Find where to start', text: 'Connect your interests with the foundations you need. Your journey starts with where you are today.' },
    context: { title: 'Know what comes next', text: 'Follow a learning sequence and explore the courses on DevTalles from your path.' },
    continuity: { title: 'Return to your own journey', text: 'Save different paths and pick up your learning with the progress you record in the app.' },
  },
  faq: {
    eyebrow: 'BEFORE YOUR FIRST STEP', title: 'Clear answers, <accent>from the start.</accent>',
    description: 'A little more about your account, your courses and how the experience works.',
    login: { question: 'Do I need Discord to sign in?', answer: 'In this first version, Discord identifies your account and keeps your paths and progress.' },
    courses: { question: 'Do I watch courses inside CODE QUEST?', answer: 'Yes. CODE QUEST shows the courses in your path, their order, the reason for each recommendation and your progress. When you want to begin one, you can open the official course on DevTalles.' },
    beginner: { question: 'Is this useful for beginners?', answer: 'Yes. The questionnaire considers your experience and current skills to find an appropriate starting point and add the foundations you need.' },
    areas: { question: 'What paths are available?', answer: 'The first version begins with Frontend React and Backend with C# / ASP.NET Core. The system is ready to add new goals and courses later.' },
    progress: { question: 'Does progress sync with DevTalles?', answer: 'Progress will be recorded in CODE QUEST based on the steps you mark. Automatic synchronization with your DevTalles progress is not planned.' },
  },
  preview: {
    eyebrow: 'AN EXAMPLE OF THE RESULT', title: 'A path designed <accent>from where you are.</accent>', description: 'You do not get a random list. Every course has a reason and prepares you for the next step.',
    goal: 'Example goal: build frontend applications with React', guide: 'Let’s find a good place to start.', listLabel: 'Conceptual example of a learning path', example: 'VISUAL EXAMPLE',
    openCourse: 'View on DevTalles', linkUnavailable: 'The link will be available when a real path is generated',
    foundations: { title: 'Foundations', level: 'Foundation', reason: 'We start with the concepts you need to move forward with confidence.', state: 'Starting point' },
    javascript: { title: 'JavaScript', level: 'Intermediate', reason: 'Build the foundations you will use when creating interfaces.', state: 'Next step' },
    react: { title: 'React', level: 'Intermediate', reason: 'Recommended for your goal once you have the required foundations.', state: 'Main goal' },
    specialization: { title: 'Specialization', level: 'Advanced', reason: 'Your path can continue based on the area you want to explore further.', state: 'Next decision' },
    outcomeTitle: 'A sequence with context', outcomeText: 'Courses, order, reasons and your progress in one place.',
  },
  closing: { eyebrow: 'YOUR NEXT STEP DOES NOT HAVE TO BE RANDOM', title: 'One goal. A starting point. <accent>Your own journey.</accent>', link: 'Back to sign-in', note: 'Start with you. Take the rest step by step.' },
} satisfies Translate<typeof landingEs>;
