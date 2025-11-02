-- Practicing COUNT, DISTINCT, and LIMIT in sql
-- SanFranciscoFilmLocations database

-- Retrieve the number of locations of the films which are directed by Woody Allen.
SELECT COUNT(Locations) FROM FilmLocations WHERE Director="Woody Allen";

-- Retrieve the number of films shot at Russian Hill.
SELECT Count(Title) FROM FilmLocations WHERE Locations="Russian Hill";

-- Retrieve the number of rows having a release year older than 1950 from the “FilmLocations” table.
SELECT Count(*) FROM FilmLocations WHERE ReleaseYear<1950;

-- Retrieve the name of all unique films released in the 21st century and onwards, along with their release years.
SELECT DISTINCT Title, ReleaseYear FROM FilmLocations WHERE ReleaseYear>=2001;

-- Retrieve the names of all the directors and their distinct films shot at City Hall.
SELECT DISTINCT Title, Director FROM FilmLocations WHERE Locations="City Hall";

-- Retrieve the number of distributors distinctly who distributed films acted by Clint Eastwood as 1st actor.
SELECT COUNT(DISTINCT Distributor) FROM FilmLocations WHERE Actor1="Clint Eastwood";

-- Retrieve the name of first 50 films distinctly.
SELECT DISTINCT Title FROM FilmLocations LIMIT 50;

-- Retrieve first 10 film names distinctly released in 2015.
SELECT DISTINCT Title FROM FilmLocations WHERE ReleaseYear=2015 LIMIT 10;

-- Retrieve the next 3 film names distinctly after first 5 films released in 2015.
SELECT DISTINCT Title FROM FilmLocations WHERE ReleaseYear=2015 LIMIT 3 OFFSET 5;
