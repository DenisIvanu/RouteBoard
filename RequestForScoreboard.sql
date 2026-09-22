SELECT db.departure_time, r.name, b.plate
FROM departure_board db
         JOIN trip t ON t.id = db.trip_id
         JOIN bus b ON b.id = t.bus_id
         JOIN route r ON r.id = t.route_id
WHERE db.stop_id = :target_stop_id AND db.departure_time >= NOW()
ORDER BY db.departure_time ASC
    LIMIT 15;