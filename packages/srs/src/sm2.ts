export type ReviewRating = 'wrong' | 'hard' | 'correct';

export interface SrsState {
  repetition: number;
  intervalDays: number;
  easeFactor: number;
  dueAt: Date;
}

export interface SrsResult extends SrsState {
  quality: number;
}

export function mapRatingToQuality(rating: ReviewRating): number {
  if (rating === 'wrong') return 1;
  if (rating === 'hard') return 3;
  return 5;
}

export function nextReview(
  state: SrsState,
  rating: ReviewRating,
  now: Date = new Date(),
): SrsResult {
  const quality = mapRatingToQuality(rating);
  let { repetition, intervalDays, easeFactor } = state;

  easeFactor = Math.max(
    1.3,
    easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)),
  );

  if (quality < 3) {
    repetition = 0;
    intervalDays = 1;
  } else {
    repetition += 1;
    if (repetition === 1) {
      intervalDays = 1;
    } else if (repetition === 2) {
      intervalDays = 3;
    } else {
      intervalDays = Math.max(1, Math.round(intervalDays * easeFactor));
    }
  }

  const dueAt = new Date(now.getTime() + intervalDays * 24 * 60 * 60 * 1000);

  return {
    repetition,
    intervalDays,
    easeFactor,
    dueAt,
    quality,
  };
}
