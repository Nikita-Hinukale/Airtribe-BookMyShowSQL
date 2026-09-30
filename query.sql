SELECT 
    m.movie_id,
    m.title AS movie_title,
    m.duration_minutes,
    m.language,
    s.show_id,
    sc.name AS screen_name,
    s.start_time,
    s.end_time,
    s.base_price
FROM theaters t
JOIN screens sc ON t.theater_id = sc.theater_id
JOIN shows s ON sc.screen_id = s.screen_id
JOIN movies m ON s.movie_id = m.movie_id
WHERE t.theater_id = 1
  AND DATE(s.start_time) = '2026-10-05'
ORDER BY m.title, s.start_time;