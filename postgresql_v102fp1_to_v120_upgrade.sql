--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard
-- from 10.2 FP1 to 12.0

  ALTER TABLE partitions rename column partition to entpartition;
  ALTER TABLE partitions rename to entpartitions;

  ALTER TABLE smartcredentials ADD registered SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD serverside SMALLINT DEFAULT NULL;

  ALTER TABLE tokens ADD teelicense SMALLINT DEFAULT NULL;

  ALTER TABLE users ADD sync_orphaned integer DEFAULT 0 NOT NULL;
  ALTER TABLE users ADD sync_unique_id VARCHAR(255) DEFAULT NULL;
  ALTER TABLE users ADD pvn_expiredate TIMESTAMP DEFAULT NULL;

  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data bytea,
    create_date timestamp without time zone NOT NULL,
    sernum numeric(12) NOT NULL,
    group_id integer NOT NULL DEFAULT 0,
    transaction_id character varying(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
