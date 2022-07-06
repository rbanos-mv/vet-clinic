/* Database schema to keep the structure of entire database. */

CREATE TABLE IF NOT EXISTS animals (
    id integer NOT NULL,
    name varchar(100) NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts integer NOT NULL,
    neutered boolean NOT NULL,
    weight_kg decimal(5,2) NOT NULL
);

ALTER TABLE animals
  ADD COLUMN species varchar(100)
;