SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
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

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
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

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country_id integer,
    sector_id integer,
    related_companies character varying,
    industry_id integer,
    bhrrc_url character varying
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
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

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id integer NOT NULL,
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

CREATE SEQUENCE public.industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industries_id_seq OWNED BY public.industries.id;


--
-- Name: legislation_statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_statements (
    id integer NOT NULL,
    legislation_id integer NOT NULL,
    statement_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_statements_id_seq OWNED BY public.legislation_statements.id;


--
-- Name: legislations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislations (
    id integer NOT NULL,
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

CREATE SEQUENCE public.legislations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislations_id_seq OWNED BY public.legislations.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    title character varying NOT NULL,
    short_title character varying NOT NULL,
    slug character varying NOT NULL,
    body_html text NOT NULL,
    "position" integer NOT NULL,
    published boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    header boolean DEFAULT true,
    footer boolean DEFAULT true
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search_aliases (
    id bigint NOT NULL,
    target tsquery,
    substitute tsquery
);


--
-- Name: search_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.search_aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.search_aliases_id_seq OWNED BY public.search_aliases.id;


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sectors (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sectors_id_seq OWNED BY public.sectors.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    id integer NOT NULL,
    statement_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapshots_id_seq OWNED BY public.snapshots.id;


--
-- Name: statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statements (
    id integer NOT NULL,
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
    latest_published boolean DEFAULT false,
    marked_not_broken_url boolean DEFAULT false,
    first_year_covered integer,
    last_year_covered integer,
    also_covers_companies character varying
);


--
-- Name: statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statements_id_seq OWNED BY public.statements.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
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

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries ALTER COLUMN id SET DEFAULT nextval('public.industries_id_seq'::regclass);


--
-- Name: legislation_statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_statements ALTER COLUMN id SET DEFAULT nextval('public.legislation_statements_id_seq'::regclass);


--
-- Name: legislations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislations ALTER COLUMN id SET DEFAULT nextval('public.legislations_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: search_aliases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_aliases ALTER COLUMN id SET DEFAULT nextval('public.search_aliases_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors ALTER COLUMN id SET DEFAULT nextval('public.sectors_id_seq'::regclass);


--
-- Name: snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots ALTER COLUMN id SET DEFAULT nextval('public.snapshots_id_seq'::regclass);


--
-- Name: statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statements ALTER COLUMN id SET DEFAULT nextval('public.statements_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: legislation_statements legislation_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_statements
    ADD CONSTRAINT legislation_statements_pkey PRIMARY KEY (id);


--
-- Name: legislations legislations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislations
    ADD CONSTRAINT legislations_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_aliases search_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_aliases
    ADD CONSTRAINT search_aliases_pkey PRIMARY KEY (id);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: statements statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statements
    ADD CONSTRAINT statements_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_companies_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_country_id ON public.companies USING btree (country_id);


--
-- Name: index_companies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_industry_id ON public.companies USING btree (industry_id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON public.companies USING gist (name public.gist_trgm_ops);


--
-- Name: index_companies_on_related_companies; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_related_companies ON public.companies USING gist (related_companies public.gist_trgm_ops);


--
-- Name: index_companies_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_sector_id ON public.companies USING btree (sector_id);


--
-- Name: index_countries_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_countries_on_code ON public.countries USING btree (code);


--
-- Name: index_countries_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_countries_on_name ON public.countries USING btree (name);


--
-- Name: index_legislation_statements_on_legislation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_statements_on_legislation_id ON public.legislation_statements USING btree (legislation_id);


--
-- Name: index_legislation_statements_on_statement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_statements_on_statement_id ON public.legislation_statements USING btree (statement_id);


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_slug ON public.pages USING btree (slug);


--
-- Name: index_sectors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sectors_on_name ON public.sectors USING btree (name);


--
-- Name: index_snapshots_on_statement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_statement_id ON public.snapshots USING btree (statement_id);


--
-- Name: index_statements_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_company_id ON public.statements USING btree (company_id);


--
-- Name: index_statements_on_latest_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_latest_published ON public.statements USING btree (latest_published) WHERE latest_published;


--
-- Name: index_statements_on_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_published ON public.statements USING btree (published);


--
-- Name: index_statements_on_verified_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statements_on_verified_by_id ON public.statements USING btree (verified_by_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: legislation_statements fk_rails_0ac00a9478; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_statements
    ADD CONSTRAINT fk_rails_0ac00a9478 FOREIGN KEY (statement_id) REFERENCES public.statements(id);


--
-- Name: statements fk_rails_6379882950; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statements
    ADD CONSTRAINT fk_rails_6379882950 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: companies fk_rails_75b15a5c36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_75b15a5c36 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: companies fk_rails_81ca530391; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_81ca530391 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: statements fk_rails_a046a1d07b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statements
    ADD CONSTRAINT fk_rails_a046a1d07b FOREIGN KEY (verified_by_id) REFERENCES public.users(id);


--
-- Name: legislation_statements fk_rails_ec23f0992a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_statements
    ADD CONSTRAINT fk_rails_ec23f0992a FOREIGN KEY (legislation_id) REFERENCES public.legislations(id);


--
-- Name: snapshots fk_rails_f6d5ca8b5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT fk_rails_f6d5ca8b5b FOREIGN KEY (statement_id) REFERENCES public.statements(id);


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
('20180625161431'),
('20180627105355'),
('20180627130240'),
('20180627172935'),
('20180707135549'),
('20181026102647'),
('20181102142511'),
('20181122133945'),
('20181207162629'),
('20190212105711');


