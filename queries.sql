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

-- Who was the last animal seen by William Tatcher?
SELECT vets.name, animals.name, visits.date_of_visit
FROM visits
INNER JOIN animals ON (animals.id = visits.animal_id)
INNER JOIN vets ON (vets.id = visits.vet_id)
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT vets.name, count(distinct visits.animal_id)
FROM visits
INNER JOIN animals ON (animals.id = visits.animal_id)
INNER JOIN vets ON (vets.id = visits.vet_id)
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.*, species.name as specialty
FROM vets
LEFT OUTER JOIN specializations ON (specializations.vet_id = vets.id)
LEFT JOIN species ON (species.id = specializations.species_id)
;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name, animals.*, visits.date_of_visit
FROM visits
INNER JOIN animals ON (animals.id = visits.animal_id)
INNER JOIN vets ON (vets.id = visits.vet_id)
WHERE vets.name = 'Stephanie Mendez'
 and visits.date_of_visit between '2020-04-01' and '2020-08-30'
GROUP BY vets.name, animals.id, visits.date_of_visit
;

-- What animal has the most visits to vets?
SELECT animals.*, count(visits.date_of_visit) as visits_to_vet
FROM visits
INNER JOIN animals ON (animals.id = visits.animal_id)
GROUP BY animals.id
ORDER BY count(visits.date_of_visit) DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.*, vets.*, visits.date_of_visit
FROM visits
INNER JOIN animals ON (animals.id = visits.animal_id)
INNER JOIN vets ON (vets.id = visits.vet_id)
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT count(*) as visits_not_to_specialist
FROM visits
INNER JOIN vets AS vetid ON (vetid.id = visits.vet_id)
INNER JOIN animals ON (animals.id = visits.animal_id)
WHERE animals.species_id NOT IN (
   SELECT coalesce(specializations.species_id,0)
   FROM vets
   LEFT OUTER JOIN specializations ON (specializations.vet_id = vets.id)
   WHERE vets.id = visits.vet_id
);

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT vets.name, species.name as specialty, count(animals.species_id)
FROM visits
INNER JOIN vets ON (vets.id = visits.vet_id)
INNER JOIN animals ON (animals.id = visits.animal_id)
INNER JOIN species ON (species.id = animals.species_id)
WHERE vets.name = 'Maisy Smith'
GROUP by vets.name, species.name
ORDER BY count(animals.species_id) desc
LIMIT 1;
