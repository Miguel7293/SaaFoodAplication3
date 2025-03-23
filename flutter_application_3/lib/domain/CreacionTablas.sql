-- Crear tabla de usuarios
CREATE TABLE users (
    profile_image TEXT,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_uid UUID PRIMARY KEY,
    type_user VARCHAR(20) NOT NULL, -- Cliente o dueño
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() -- Fecha de registro
);

-- Crear tabla de restaurantes
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    image_of_local TEXT,
    contact_number VARCHAR(20) NOT NULL,
    horario VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    state VARCHAR(20), -- Abierto o cerrado
    id_dueno UUID NOT NULL REFERENCES users(user_uid), -- Relación con usuario dueño
    created_at TIMESTAMP DEFAULT NOW() -- Fecha de registro

);

-- Crear tabla de cartas
CREATE TABLE carta (
    carta_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL, -- Ejemplo: bebida, comida
    description TEXT,
    rest_cart INT NOT NULL REFERENCES restaurants(restaurant_id), -- Relación con restaurante
    updated_at TIMESTAMP DEFAULT NOW(), -- Última actualización
    state bool default false
);

-- Crear tabla de platos
CREATE TABLE plates (
    plate_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(8, 2) NOT NULL,
    available BOOLEAN DEFAULT TRUE, -- Indica si el plato está disponible
    image TEXT,
    cart_id INT NOT NULL REFERENCES carta(carta_id) -- Relación con la carta
);

-- Crear tabla de calificaciones (rates)
CREATE TABLE rates (
    rate_id SERIAL PRIMARY KEY,
    points INT CHECK (points BETWEEN 1 AND 5), -- Puntuación entre 1 y 5
    description TEXT,
    user_restaurant UUid NOT NULL REFERENCES users(user_uid), -- Usuario que califica
    restaurant_id INT NOT NULL REFERENCES restaurants(restaurant_id), -- Restaurante calificado
    created_at TIMESTAMP DEFAULT NOW() -- Fecha de la calificación

    //agrega unique en restaurant_id con user_restaurant
);


ALTER TABLE rates ADD CONSTRAINT unique_user_restaurant_rate UNIQUE (user_restaurant, restaurant_id); --- un usuario pueda calificar un restaurante solo una vez










INSERT INTO restaurants (
    name, 
    location, 
    image_of_local, 
    contact_number, 
    horario, 
    category, 
    description, 
    state, 
    id_dueno, 
    created_at,
    coordinates
) VALUES
('Mayta Restaurant', 'Av. Pardo y Aliaga, Lima, Perú', 'https://elcomercio.pe/resizer/mrauq-1m2NOGbEMiCAlQGF42IT0=/1200x900/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/LIME7AFJ7BGSDINO4PPO4T4QGQ.jpg', '+51 123 456 789', '08:00 - 22:00', 'Italiana', 'Un restaurante italiano con una gran variedad de pastas y pizzas.', 'Abierto', '97806ace-eea2-4c16-97ec-7e76bd8a1f84', '2025-01-23 12:00:00', '-12.0464,-77.0334'),
('Mantela Restaurant', 'Jirón de la Unión, Lima, Perú', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/29/28/66/bienvenido-a-mantela.jpg', '+51 987 654 321', '10:00 - 20:00', 'Mexicana', 'Disfruta de los mejores tacos, burritos y guacamole en un ambiente vibrante.', 'Abierto', '97806ace-eea2-4c16-97ec-7e76bd8a1f84', '2025-01-23 12:00:00', '-12.0455,-77.0328'),
('Sessions Restaurant', 'Av. Pueyrredón, Buenos Aires, Argentina', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/e2/dc/48/sessions-restaurant-acceso.jpg', '+54 11 2345 6789', '10:00 - 20:00', 'Francesa', 'Comida francesa gourmet con platos tradicionales y modernos.', 'Abierto', '97806ace-eea2-4c16-97ec-7e76bd8a1f84', '2025-01-23 12:00:00', '-34.6010,-58.3796'),
('Panela Ajonjolí Restaurant', 'Calle Las Palmas, Bogotá, Colombia', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/da/f1/f0/panela-ajonjoli.jpg', '+57 1 987 654 321', '10:00 - 20:00', 'Marisquería', 'Ofrecemos lo mejor del mar con mariscos frescos y platos de la costa.', 'Cerrado', '97806ace-eea2-4c16-97ec-7e76bd8a1f84', '2025-01-23 12:00:00', '4.7114,-74.0705');

