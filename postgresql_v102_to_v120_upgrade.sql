--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard
-- from 10.2 to 12.0

  ALTER TABLE partitions rename column partition to entpartition;
  ALTER TABLE partitions rename to entpartitions;

  ALTER TABLE smartcredentials ADD mobilelicense SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD idassuredlicense SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD registered SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD serverside SMALLINT DEFAULT NULL;

  ALTER TABLE tokens ADD mobilelicense SMALLINT DEFAULT NULL;
  ALTER TABLE tokens ADD tvslicense SMALLINT DEFAULT NULL;
  ALTER TABLE tokens ADD teelicense SMALLINT DEFAULT NULL;

  ALTER TABLE digitalids ADD dn VARCHAR(255) DEFAULT NULL;

  ALTER TABLE users ADD biometrics bytea DEFAULT NULL;
  ALTER TABLE users ADD sync_orphaned integer DEFAULT 0 NOT NULL;
  ALTER TABLE users ADD sync_unique_id VARCHAR(255) DEFAULT NULL;
  ALTER TABLE users ADD pvn_expiredate TIMESTAMP DEFAULT NULL;

  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE biometrics
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    vendorid VARCHAR(100) NOT NULL,
    state VARCHAR(20) NOT NULL,
    enroll_state VARCHAR(20) NOT NULL,
    enroll_date TIMESTAMP NOT NULL,
    lastused_date TIMESTAMP NOT NULL,
    CONSTRAINT userbiometrics_pkey PRIMARY KEY (group_id, user_id, vendorid),
    CONSTRAINT "biometric User key" FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data bytea,
    create_date timestamp without time zone NOT NULL,
    sernum numeric(12) NOT NULL,
    group_id integer NOT NULL DEFAULT 0,
    transaction_id character varying(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
