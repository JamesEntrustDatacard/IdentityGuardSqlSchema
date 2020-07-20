--
-- Copyright 2004-2017 Entrust. All rights reserved.
--
-- This file defines the database schema used to upgrade Entrust IdentityGuard
-- from 11.0 to 12.0

  CREATE TABLE anonymous_challenges
  (
    anon_challenge_data bytea,
    create_date timestamp without time zone NOT NULL,
    sernum numeric(12) NOT NULL,
    group_id integer NOT NULL DEFAULT 0,
    transaction_id character varying(255),
    CONSTRAINT anon_challenge_pkey PRIMARY KEY (sernum)
  );
