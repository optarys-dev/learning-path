import { useLayoutEffect, useRef, useState } from 'react';

interface TrackPoint {
  x: number;
  y: number;
}

interface TrackSegment {
  end: TrackPoint;
  start: TrackPoint;
}

interface TrackSize {
  height: number;
  segments: TrackSegment[];
  width: number;
}

interface RouteRaceTrackProps {
  courseKeys: string[];
}

function connectionPoints(first: DOMRect, second: DOMRect, list: DOMRect): TrackSegment {
  const firstCenter = { x: first.left - list.left + first.width / 2, y: first.top - list.top + first.height / 2 };
  const secondCenter = { x: second.left - list.left + second.width / 2, y: second.top - list.top + second.height / 2 };
  const horizontal = Math.abs(secondCenter.x - firstCenter.x) > Math.abs(secondCenter.y - firstCenter.y) * .6;

  if (horizontal) {
    const goesRight = secondCenter.x > firstCenter.x;
    return {
      start: { x: goesRight ? first.right - list.left : first.left - list.left, y: firstCenter.y },
      end: { x: goesRight ? second.left - list.left : second.right - list.left, y: secondCenter.y },
    };
  }

  const goesDown = secondCenter.y > firstCenter.y;
  return {
    start: { x: firstCenter.x, y: goesDown ? first.bottom - list.top : first.top - list.top },
    end: { x: secondCenter.x, y: goesDown ? second.top - list.top : second.bottom - list.top },
  };
}

/** Draws one continuous guide between card edges, leaving numbered stations clear. */
export function RouteRaceTrack({ courseKeys }: RouteRaceTrackProps) {
  const svgRef = useRef<SVGSVGElement>(null);
  const [track, setTrack] = useState<TrackSize | null>(null);
  const courseKeySignature = courseKeys.join('|');

  useLayoutEffect(() => {
    const svg = svgRef.current;
    const list = svg?.parentElement?.querySelector<HTMLOListElement>('.my-path__course-list');
    if (!svg || !list) return undefined;

    let frame = 0;
    const measure = () => {
      const bounds = list.getBoundingClientRect();
      const stations = [...list.querySelectorAll<HTMLElement>('.my-path__step-marker')]
        .map(station => station.getBoundingClientRect());
      const segments = stations.slice(0, -1).map((station, index) => connectionPoints(station, stations[index + 1], bounds));
      setTrack({ width: bounds.width, height: bounds.height, segments });
    };

    const scheduleMeasure = () => {
      cancelAnimationFrame(frame);
      frame = requestAnimationFrame(measure);
    };

    const observer = new ResizeObserver(scheduleMeasure);
    observer.observe(list);
    window.addEventListener('resize', scheduleMeasure);
    scheduleMeasure();

    return () => {
      cancelAnimationFrame(frame);
      observer.disconnect();
      window.removeEventListener('resize', scheduleMeasure);
    };
  }, [courseKeySignature]);

  return (
    <svg ref={svgRef} className="my-path__race-track" aria-hidden="true" focusable="false"
      viewBox={`0 0 ${track?.width ?? 0} ${track?.height ?? 0}`} preserveAspectRatio="none">
      {track?.segments.map((segment, index) => {
        const horizontal = Math.abs(segment.end.x - segment.start.x) > Math.abs(segment.end.y - segment.start.y) * .6;
        const curve = horizontal
          ? Math.max(28, Math.abs(segment.end.x - segment.start.x) * .28)
          : Math.max(28, Math.abs(segment.end.y - segment.start.y) * .28);
        const path = horizontal
          ? `M ${segment.start.x} ${segment.start.y} C ${segment.start.x + Math.sign(segment.end.x - segment.start.x) * curve} ${segment.start.y}, ${segment.end.x - Math.sign(segment.end.x - segment.start.x) * curve} ${segment.end.y}, ${segment.end.x} ${segment.end.y}`
          : `M ${segment.start.x} ${segment.start.y} C ${segment.start.x} ${segment.start.y + Math.sign(segment.end.y - segment.start.y) * curve}, ${segment.end.x} ${segment.end.y - Math.sign(segment.end.y - segment.start.y) * curve}, ${segment.end.x} ${segment.end.y}`;
        return <path key={`${courseKeys[index]}-${courseKeys[index + 1]}`} className="my-path__race-line" d={path} />;
      })}
    </svg>
  );
}