--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard 
-- from 10.2 to 12.0.

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

  ALTER TABLE smartcredentials ADD mobilelicense SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD idassuredlicense SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD registered SMALLINT DEFAULT NULL;
  ALTER TABLE smartcredentials ADD serverside SMALLINT DEFAULT NULL;

  ALTER TABLE tokens ADD mobilelicense SMALLINT DEFAULT NULL;
  ALTER TABLE tokens ADD tvslicense SMALLINT DEFAULT NULL;
  ALTER TABLE tokens ADD teelicense SMALLINT DEFAULT NULL;

  ALTER TABLE digitalids ADD dn NVARCHAR(255) DEFAULT NULL;

  ALTER TABLE users ADD biometrics image DEFAULT NULL;
  ALTER TABLE users ADD sync_orphaned integer DEFAULT 0 NOT NULL;
  ALTER TABLE users ADD sync_unique_id NVARCHAR(255) DEFAULT NULL;
  ALTER TABLE users ADD pvn_expiredate DATETIME DEFAULT NULL;

  CREATE INDEX users_syncuid_index ON users (sync_unique_id);

  CREATE TABLE biometrics
  (
    group_id integer DEFAULT 0 NOT NULL,
    user_id NVARCHAR(255) NOT NULL,
    vendorid NVARCHAR(100) NOT NULL,
    state NVARCHAR(20) NOT NULL,
    enroll_state NVARCHAR(20) NOT NULL,
    enroll_date DATETIME NOT NULL,
    lastused_date DATETIME NOT NULL,
    CONSTRAINT userbiometrics_pkey PRIMARY KEY (group_id, user_id, vendorid),
    CONSTRAINT biometric_user_key FOREIGN KEY (group_id, user_id)
       REFERENCES users (group_id, user_id) ON DELETE CASCADE
  );

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data image,
    create_date DATETIME NOT NULL,
    sernum DECIMAL(12, 0) NOT NULL,
    group_id integer DEFAULT 0 NOT NULL,
    transaction_id VARCHAR(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
