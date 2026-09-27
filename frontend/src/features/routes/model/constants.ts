export const routeLimits = { courses: 30, goalLength: 1000, explanationLength: 4000 } as const;
export const manualRecommendationMethod = 'manual-v1';
export const routeStorage = {
  courseState: 'learning-path:course-state',
  pendingRecommendation: 'learning-path:pending-recommendation:v1',
  courseStateChanged: 'learning-path:course-state-change',
} as const;
