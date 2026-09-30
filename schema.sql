CREATE DATABASE IF NOT EXISTS bookmyshow_db;
USE bookmyshow_db;

-- 1. Theaters Table
CREATE TABLE theaters (
    theater_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Screens Table
CREATE TABLE screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    theater_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    FOREIGN KEY (theater_id) REFERENCES theaters(theater_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Movies Table
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    duration_minutes INT NOT NULL,
    language VARCHAR(50) NOT NULL,
    release_date DATE NOT NULL
) ENGINE=InnoDB;

-- 4. Shows Table
CREATE TABLE shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id) ON DELETE CASCADE,
    INDEX idx_theater_date (screen_id, start_time)
) ENGINE=InnoDB;

-- 5. Seats Table 
CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_id INT NOT NULL,
    row_number VARCHAR(5) NOT NULL, 
    seat_number INT NOT NULL,        
    seat_type ENUM('REGULAR', 'PREMIUM', 'VIP') NOT NULL DEFAULT 'REGULAR',
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id) ON DELETE CASCADE,
    UNIQUE KEY uk_screen_seat (screen_id, row_number, seat_number)
) ENGINE=InnoDB;

-- 6. Show Seats Table 
CREATE TABLE show_seats (
    show_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    seat_id INT NOT NULL,
    status ENUM('AVAILABLE', 'LOCKED', 'BOOKED') NOT NULL DEFAULT 'AVAILABLE',
    version INT NOT NULL DEFAULT 0, 
    FOREIGN KEY (show_id) REFERENCES shows(show_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id) ON DELETE CASCADE,
    UNIQUE KEY uk_show_seat (show_id, seat_id)
) ENGINE=InnoDB;

-- 7. Bookings Table
CREATE TABLE bookings (
    booking_id VARCHAR(36) PRIMARY KEY, -- UUID
    user_id INT NOT NULL,
    show_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (show_id) REFERENCES shows(show_id)
) ENGINE=InnoDB;

-- 8. Booking Items 
CREATE TABLE booking_items (
    booking_item_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(36) NOT NULL,
    show_seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (show_seat_id) REFERENCES show_seats(show_seat_id),
    UNIQUE KEY uk_show_seat_booked (show_seat_id)
) ENGINE=InnoDB;


-- ==========================================
-- SAMPLE DATA
-- ==========================================

INSERT INTO theaters (name, city, address) VALUES ('PVR Cinemas: Phoenix Mills', 'Mumbai', 'Lower Parel, Mumbai');
INSERT INTO screens (theater_id, name, total_seats) VALUES (1, 'Audi 1 - IMAX', 100);
INSERT INTO movies (movie_id, title, duration_minutes, language, release_date) VALUES (1, 'Interstellar (Re-release)', 169, 'English', '2026-09-01');

-- Insert Show
INSERT INTO shows (show_id, movie_id, screen_id, start_time, end_time, base_price) 
VALUES (1, 1, 1, '2026-10-05 18:30:00', '2026-10-05 21:20:00', 450.00);

-- Insert Seats for Screen 1 (Row A, Seats 1 and 2)
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES (1, 'A', 1, 'PREMIUM'), (1, 'A', 2, 'PREMIUM');

-- Link Seats to Show Inventory
INSERT INTO show_seats (show_id, seat_id, status) VALUES (1, 1, 'AVAILABLE'), (1, 2, 'AVAILABLE');