/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name like '%mon';

SELECT name from animals WHERE date_of_birth between '2016-01-01' and '2019-12-31';

SELECT name from animals WHERE neutered = true and escape_attempts < 3;

SELECT date_of_birth from animals WHERE name = 'Agumon' or name = 'Pikachu';

SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;

SELECT * from animals WHERE neutered = true;

SELECT * from animals WHERE name <> 'Gabumon';

SELECT * from animals WHERE weight_kg between 10.4 and 17.3;


SELECT * FROM animals; -- state before transaction starts
BEGIN;
UPDATE animals set species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals; -- state after rollback

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals; -- state after commit

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals; -- state after rollback

BEGIN;
DELETE FROM animals where date_of_birth > '2022-01-01';
SAVEPOINT AFTERDELETE;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO AFTERDELETE;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals; -- state after commit

SELECT count(*) FROM animals;

SELECT count(*) FROM animals where escape_attempts = 0;

SELECT avg(weight_kg) FROM animals;

SELECT neutered, max(escape_attempts) FROM animals GROUP BY neutered;

SELECT species, min(weight_kg), max(weight_kg) FROM animals GROUP BY species;

SELECT species, avg(escape_attempts) FROM animales WHERE date_of_birth between '1990-01-01' and '2000-12-31' GROUP BY species;

