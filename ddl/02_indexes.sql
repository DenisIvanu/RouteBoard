-- 1. Покрытие для остановок: быстро находим все маршруты, проходящие через нужную остановку
CREATE INDEX idx_route_stop_stop_id ON route_stop(stop_id)
    INCLUDE (route_id, dep_offset_min);

-- 2. Покрытие для рейсов: быстро отсекаем прошлые даты и джойним по маршруту
CREATE INDEX idx_trip_date_route ON trip(trip_date, route_id)
    INCLUDE (start_time, bus_id);

-- 3. Стандартные индексы для связки по первичным ключам (создаются автоматически, но для джойнов нужны)
-- bus(id), route(id), stop(id)