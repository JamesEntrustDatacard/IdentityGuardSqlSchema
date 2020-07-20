--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard 
-- from 10.2 FP1 to 12.0.

-- Add the following statement to place the Entrust IdentityGuard tables in
-- your sql server database. Substitute your database name for <DBNAME>.
--
-- USE <DBNAME>; 
--
-- e.g., 
-- USE igdb;
--
 
  EXEC sp_RENAME 'partitions.partition', 'entpartition', 'COLUMN';
  EXEC sp_RENAME 'partitions', 'entpartitions';

  ALTER TABLE smartcredentials ADD registered SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD serverside SMALLINT DEFAULT NULL;

  ALTER TABLE tokens ADD teelicense SMALLINT DEFAULT NULL;

  ALTER TABLE users ADD sync_orphaned integer DEFAULT 0 NOT NULL;
  ALTER TABLE users ADD sync_unique_id NVARCHAR(255) DEFAULT NULL;
  ALTER TABLE users ADD pvn_expiredate DATETIME DEFAULT NULL;

  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data image,
    create_date DATETIME NOT NULL,
    sernum DECIMAL(12, 0) NOT NULL,
    group_id integer DEFAULT 0 NOT NULL,
    transaction_id VARCHAR(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
