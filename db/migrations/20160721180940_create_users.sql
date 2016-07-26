-- +micrate Up
BEGIN;

CREATE TABLE users(
  id INTEGER NOT NULL,
  uuid character varying NOT NULL,
  email character varying NOT NULL,
  name character varying NOT NULL,
  encrypted_password VARCHAR NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  admin boolean default false
);

CREATE SEQUENCE users_id_seq
  START WITH 1121
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;
ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

COMMIT;

-- +micrate Down
DROP TABLE users;