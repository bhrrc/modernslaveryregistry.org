SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_storage_attachments_id_seq OWNED BY active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_storage_blobs_id_seq OWNED BY active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country_id integer,
    sector_id integer,
    subsidiary_names character varying,
    industry_id integer
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE countries (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lat double precision,
    lng double precision
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE industries (
    id bigint NOT NULL,
    sector_name character varying,
    sector_code integer,
    industry_group_name character varying,
    industry_group_code integer,
    name character varying,
    industry_code integer
);


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industries_id_seq OWNED BY industries.id;


--
-- Name: legislation_statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legislation_statements (
    id bigint NOT NULL,
    legislation_id integer NOT NULL,
    statement_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legislation_statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legislation_statements_id_seq OWNED BY legislation_statements.id;


--
-- Name: legislations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legislations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    icon character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    requires_statement_attributes character varying DEFAULT ''::character varying NOT NULL,
    include_in_compliance_stats boolean DEFAULT false NOT NULL
);


--
-- Name: legislations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legislations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legislations_id_seq OWNED BY legislations.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pages (
    id bigint NOT NULL,
    title character varying NOT NULL,
    short_title character varying NOT NULL,
    slug character varying NOT NULL,
    body_html text NOT NULL,
    "position" integer NOT NULL,
    published boolean
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sectors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sectors_id_seq OWNED BY sectors.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshots (
    id bigint NOT NULL,
    content_data bytea NOT NULL,
    content_type character varying NOT NULL,
    statement_id integer,
    image_content_type character varying,
    image_content_data bytea,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapshots_id_seq OWNED BY snapshots.id;


--
-- Name: statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statements (
    id bigint NOT NULL,
    company_id integer NOT NULL,
    url character varying NOT NULL,
    date_seen date NOT NULL,
    approved_by_board character varying,
    approved_by character varying,
    signed_by_director boolean,
    signed_by character varying,
    link_on_front_page boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    broken_url boolean,
    verified_by_id integer,
    published boolean DEFAULT false,
    contributor_email character varying,
    latest boolean DEFAULT false,
    latest_published boolean DEFAULT false,
    marked_not_broken_url boolean DEFAULT false,
    first_year_covered integer,
    last_year_covered integer,
    also_covers_companies character varying
);


--
-- Name: statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statements_id_seq OWNED BY statements.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('active_storage_blobs_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries ALTER COLUMN id SET DEFAULT nextval('industries_id_seq'::regclass);


--
-- Name: legislation_statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislation_statements ALTER COLUMN id SET DEFAULT nextval('legislation_statements_id_seq'::regclass);


--
-- Name: legislations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislations ALTER COLUMN id SET DEFAULT nextval('legislations_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors ALTER COLUMN id SET DEFAULT nextval('sectors_id_seq'::regclass);


--
-- Name: snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots ALTER COLUMN id SET DEFAULT nextval('snapshots_id_seq'::regclass);


--
-- Name: statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements ALTER COLUMN id SET DEFAULT nextval('statements_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: legislation_statements legislation_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislation_statements
    ADD CONSTRAINT legislation_statements_pkey PRIMARY KEY (id);


--
-- Name: legislations legislations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislations
    ADD CONSTRAINT legislations_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: statements statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT statements_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON active_storage_blobs USING btree (key);


--
-- Name: index_companies_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_country_id ON companies USING btree (country_id);


--
-- Name: index_companies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_industry_id ON companies USING btree (industry_id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON companies USING gist (name gist_trgm_ops);


--
-- Name: index_companies_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_sector_id ON companies USING btree (sector_id);


--
-- Name: index_companies_on_subsidiary_names; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_subsidiary_names ON companies USING gist (subsidiary_names gist_trgm_ops);


--
-- Name: index_countries_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_countries_on_code ON countries USING btree (code);


--
-- Name: index_countries_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_countries_on_name ON countries USING btree (name);


--
-- Name: index_legislation_statements_on_legislation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_statements_on_legislation_id ON legislation_statements USING btree (legislation_id);


--
-- Name: index_legislation_statements_on_statement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_statements_on_statement_id ON legislation_statements USING btree (statement_id);


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_slug ON pages USING btree (slug);


--
-- Name: index_sectors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sectors_on_name ON sectors USING btree (name);


--
-- Name: index_snapshots_on_statement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_statement_id ON snapshots USING btree (statement_id);


--
-- Name: index_statements_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_company_id ON statements USING btree (company_id);


--
-- Name: index_statements_on_latest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_latest ON statements USING btree (latest) WHERE latest;


--
-- Name: index_statements_on_latest_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_latest_published ON statements USING btree (latest_published) WHERE latest_published;


--
-- Name: index_statements_on_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_published ON statements USING btree (published);


--
-- Name: index_statements_on_verified_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_verified_by_id ON statements USING btree (verified_by_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: legislation_statements fk_rails_0ac00a9478; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislation_statements
    ADD CONSTRAINT fk_rails_0ac00a9478 FOREIGN KEY (statement_id) REFERENCES statements(id);


--
-- Name: statements fk_rails_6379882950; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT fk_rails_6379882950 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: companies fk_rails_75b15a5c36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_75b15a5c36 FOREIGN KEY (country_id) REFERENCES countries(id);


--
-- Name: companies fk_rails_81ca530391; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_81ca530391 FOREIGN KEY (industry_id) REFERENCES industries(id);


--
-- Name: statements fk_rails_a046a1d07b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT fk_rails_a046a1d07b FOREIGN KEY (verified_by_id) REFERENCES users(id);


--
-- Name: legislation_statements fk_rails_ec23f0992a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislation_statements
    ADD CONSTRAINT fk_rails_ec23f0992a FOREIGN KEY (legislation_id) REFERENCES legislations(id);


--
-- Name: snapshots fk_rails_f6d5ca8b5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT fk_rails_f6d5ca8b5b FOREIGN KEY (statement_id) REFERENCES statements(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170323204346'),
('20170324211110'),
('20170325205137'),
('20170325205215'),
('20170325215024'),
('20170325215806'),
('20170326071845'),
('20170327124043'),
('20170329123750'),
('20170329213619'),
('20170329215441'),
('20170407030724'),
('20170410034550'),
('20170414181818'),
('20170415181516'),
('20170415191533'),
('20170415221522'),
('20170415223753'),
('20170415235342'),
('20170416185534'),
('20170417124656'),
('20170417172011'),
('20170503200854'),
('20170524120753'),
('20170527153854'),
('20170527222353'),
('20170531092039'),
('20170602144706'),
('20170610060421'),
('20170714091607'),
('20170714130014'),
('20170718104813'),
('20170718153034'),
('20170811071500'),
('20171115160523'),
('20171115163643'),
('20171115190959'),
('20171115191103'),
('20171115194032'),
('20171218194251'),
('20171218195354'),
('20171218195517'),
('20180110102417'),
('20180110113910'),
('20180217165226'),
('20180217165315'),
('20180218110244'),
('20180218114433'),
('20180420213924'),
('20180420214008'),
('20180420221500'),
('20180420221557'),
('20180509104410'),
('20180509104411'),
('20180519060859'),
('20180621082254'),
('20180625155843'),
('20180625161431');


