
SELECT GetAvailableSeats('Новосибирск-Главный - Бердск', '2024-10-10 08:00:00') AS Скорый;
SELECT SLEEP(2);
SELECT GetAvailableSeats('Новосибирск-Главный - Обь', '2024-10-11 09:00:00') AS Пассажирский;
SELECT SLEEP(2);

SELECT CountTicketsByStatus() AS TicketCounts;
