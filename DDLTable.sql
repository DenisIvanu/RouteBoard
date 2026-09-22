-- Города
CREATE TABLE city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Остановки
CREATE TABLE stop (
    id SERIAL PRIMARY KEY,
    city_id INT REFERENCES city(id),
    name VARCHAR(150) NOT NULL
);

-- Маршруты (Граф)
CREATE TABLE route (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL, -- Например: "Москва - Тверь - Великий Новгород"
    direction VARCHAR(50) NOT NULL -- Например: "Туда" / "Обратно"
);

-- Связь маршрута и остановок (Путь автобуса)
CREATE TABLE route_stop (
    id SERIAL PRIMARY KEY,
    route_id INT REFERENCES route(id),
    stop_id INT REFERENCES stop(id),
    seq INT NOT NULL, -- Порядковый номер остановки в маршруте
    dep_offset_min INT NOT NULL, -- Смещение в минутах от времени старта рейса (start_time)
    UNIQUE(route_id, seq)
);

-- Автобусы
CREATE TABLE bus (
    id SERIAL PRIMARY KEY,
    route_id INT REFERENCES route(id), -- Обычно автобус закреплен за маршрутом
    plate VARCHAR(20) NOT NULL, -- Гос. номер
    capacity INT NOT NULL
);

-- Расписание (Фактические рейсы)
CREATE TABLE trip (
    id SERIAL PRIMARY KEY,
    bus_id INT REFERENCES bus(id),
    route_id INT REFERENCES route(id),
    trip_date DATE NOT NULL, -- Дата выезда
    start_time TIME NOT NULL -- Время отправления из начальной точки маршрута
);

-- Таблица витрины
CREATE TABLE departure_board (
    stop_id INT NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    trip_id INT NOT NULL,
    PRIMARY KEY (stop_id, departure_time)
);

-- 1. Покрытие для остановок: быстро находим все маршруты, проходящие через нужную остановку
CREATE INDEX idx_route_stop_stop_id ON route_stop(stop_id)
    INCLUDE (route_id, dep_offset_min);

-- 2. Покрытие для рейсов: быстро отсекаем прошлые даты и джойним по маршруту
CREATE INDEX idx_trip_date_route ON trip(trip_date, route_id)
    INCLUDE (start_time, bus_id);

-- 3. Стандартные индексы для связки по первичным ключам (создаются автоматически, но для джойнов нужны)
-- bus(id), route(id), stop(id)