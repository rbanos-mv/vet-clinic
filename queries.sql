/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * from animals WHERE name like '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name from animals WHERE date_of_birth between '2016-01-01' and '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name from animals WHERE neutered = true and escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth from animals WHERE name = 'Agumon' or name = 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * from animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * from animals WHERE name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
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

-- How many animals are there?
SELECT count(*) FROM animals;

-- How many animals have never tried to escape?
SELECT count(*) FROM animals where escape_attempts = 0;

-- What is the average weight of animals?
SELECT avg(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, max(escape_attempts) FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, min(weight_kg), max(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, avg(escape_attempts) FROM animales WHERE date_of_birth between '1990-01-01' and '2000-12-31' GROUP BY species;

-- What animals belong to Melody Pond?
SELECT owners.full_name as owner, animals.* FROM animals INNER JOIN owners ON (animals.owner_id = owners.id) WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT species.name as species_name, animals.* FROM animals INNER JOIN species ON (animals.species_id = species.id) WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name as owner, animals.* FROM owners LEFT OUTER JOIN animals ON (animals.owner_id = owners.id);

-- How many animals are there per species?
SELECT species.name as species_name, count(animals.id) FROM species LEFT OUTER JOIN animals ON (animals.species_id = species.id) GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name as owner, species.name as species_name, animals.* FROM animals INNER JOIN owners ON (animals.owner_id = owners.id) INNER JOIN species ON (animals.species_id = species.id) WHERE species.name = 'Digimon' and owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name as owner, animals.* FROM animals INNER JOIN owners ON (animals.owner_id = owners.id) WHERE owners.full_name = 'Dean Winchester' and escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name as owner, count(animals.id) FROM animals INNER JOIN owners ON (animals.owner_id = owners.id) GROUP BY owners.full_name ORDER BY count(animals.id) DESC LIMIT 1;
