-- ============================================================
-- Friends Automotive — Supabase PostgreSQL Schema
-- Run this ONCE in: Supabase Dashboard → SQL Editor → Run
-- ============================================================

CREATE TABLE IF NOT EXISTS settings (
  id             INTEGER PRIMARY KEY DEFAULT 1,
  shop_name      TEXT DEFAULT 'Friends Automotive',
  tagline        TEXT DEFAULT 'Complete Car Solution',
  address        TEXT DEFAULT 'Sector 77 Shikohpur Road beside Bharat Petroleum, Gurugram 122004',
  phone          TEXT DEFAULT '9654483936',
  email          TEXT DEFAULT 'rshankar929@gmail.com',
  gstin          TEXT DEFAULT '06JCDPS8205K2Z4',
  pan            TEXT DEFAULT 'JCDPS8205K',
  bank_name      TEXT DEFAULT 'HDFC BANK',
  account_no     TEXT DEFAULT '50200062379206',
  ifsc           TEXT DEFAULT 'HDFC0009433',
  bank_branch    TEXT DEFAULT 'GURGAON',
  upi_id         TEXT DEFAULT '',
  labor_rate     INTEGER DEFAULT 500,
  invoice_prefix TEXT DEFAULT 'FRA',
  invoice_terms  TEXT DEFAULT '1. Warranty on parts as per manufacturer terms.
2. Labour warranty: 1 month.
3. Goods once sold will not be taken back.',
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS customers (
  id           SERIAL PRIMARY KEY,
  name         TEXT NOT NULL,
  company_name TEXT DEFAULT '',
  phone        TEXT NOT NULL,
  email        TEXT DEFAULT '',
  address      TEXT DEFAULT '',
  gstin        TEXT DEFAULT '',
  type         TEXT DEFAULT 'individual',
  notes        TEXT DEFAULT '',
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vehicles (
  id               SERIAL PRIMARY KEY,
  customer_id      INTEGER REFERENCES customers(id) ON DELETE SET NULL,
  reg_no           TEXT NOT NULL,
  make             TEXT NOT NULL DEFAULT '',
  model            TEXT DEFAULT '',
  variant          TEXT DEFAULT '',
  year             INTEGER,
  vin              TEXT DEFAULT '',
  engine_no        TEXT DEFAULT '',
  color            TEXT DEFAULT '',
  fuel_type        TEXT DEFAULT 'petrol',
  odometer         INTEGER DEFAULT 0,
  insurance_expiry DATE,
  last_service     DATE,
  notes            TEXT DEFAULT '',
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS parts (
  id             SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  part_no        TEXT DEFAULT '',
  hsn_code       TEXT DEFAULT '',
  gst            NUMERIC(5,2) DEFAULT 18,
  purchase_price NUMERIC(10,2) DEFAULT 0,
  selling_price  NUMERIC(10,2) DEFAULT 0,
  qty            INTEGER DEFAULT 0,
  min_qty        INTEGER DEFAULT 2,
  unit           TEXT DEFAULT 'nos',
  category       TEXT DEFAULT 'spare',
  rack           TEXT DEFAULT '',
  notes          TEXT DEFAULT '',
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS job_cards (
  id                 SERIAL PRIMARY KEY,
  customer_id        INTEGER REFERENCES customers(id) ON DELETE SET NULL,
  vehicle_id         INTEGER REFERENCES vehicles(id) ON DELETE SET NULL,
  customer_name      TEXT DEFAULT '',
  vehicle_reg        TEXT DEFAULT '',
  status             TEXT DEFAULT 'open',
  priority           TEXT DEFAULT 'normal',
  technician_name    TEXT DEFAULT '',
  odometer           INTEGER,
  estimated_delivery DATE,
  complaint          TEXT DEFAULT '',
  diagnosis          TEXT DEFAULT '',
  notes              TEXT DEFAULT '',
  items              JSONB DEFAULT '[]',
  subtotal           NUMERIC(10,2) DEFAULT 0,
  gst_total          NUMERIC(10,2) DEFAULT 0,
  grand_total        NUMERIC(10,2) DEFAULT 0,
  created_at         TIMESTAMPTZ DEFAULT NOW(),
  updated_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS invoices (
  id                  SERIAL PRIMARY KEY,
  type                TEXT DEFAULT 'invoice',
  job_card_id         INTEGER REFERENCES job_cards(id) ON DELETE SET NULL,
  customer_id         INTEGER REFERENCES customers(id) ON DELETE SET NULL,
  vehicle_id          INTEGER REFERENCES vehicles(id) ON DELETE SET NULL,
  customer_name       TEXT DEFAULT '',
  company_name        TEXT DEFAULT '',
  customer_phone      TEXT DEFAULT '',
  customer_address    TEXT DEFAULT '',
  customer_gstin      TEXT DEFAULT '',
  customer_email      TEXT DEFAULT '',
  vehicle_reg         TEXT DEFAULT '',
  vehicle_details     TEXT DEFAULT '',
  odometer            INTEGER,
  vin_no              TEXT DEFAULT '',
  engine_no           TEXT DEFAULT '',
  vehicle_color       TEXT DEFAULT '',
  vehicle_fuel        TEXT DEFAULT '',
  items               JSONB DEFAULT '[]',
  subtotal            NUMERIC(10,2) DEFAULT 0,
  gst_total           NUMERIC(10,2) DEFAULT 0,
  cgst_total          NUMERIC(10,2) DEFAULT 0,
  sgst_total          NUMERIC(10,2) DEFAULT 0,
  grand_total         NUMERIC(10,2) DEFAULT 0,
  additional_discount NUMERIC(10,2) DEFAULT 0,
  adjustment          NUMERIC(10,2) DEFAULT 0,
  payment_status      TEXT DEFAULT 'pending',
  payment_method      TEXT DEFAULT '',
  amount_paid         NUMERIC(10,2) DEFAULT 0,
  date                DATE DEFAULT CURRENT_DATE,
  due_date            DATE,
  notes               TEXT DEFAULT '',
  terms_conditions    TEXT DEFAULT '',
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-update updated_at on every row change
CREATE OR REPLACE FUNCTION _updated_at()
RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;

DO $$ BEGIN CREATE TRIGGER t_customers  BEFORE UPDATE ON customers  FOR EACH ROW EXECUTE FUNCTION _updated_at(); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TRIGGER t_vehicles   BEFORE UPDATE ON vehicles   FOR EACH ROW EXECUTE FUNCTION _updated_at(); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TRIGGER t_parts      BEFORE UPDATE ON parts      FOR EACH ROW EXECUTE FUNCTION _updated_at(); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TRIGGER t_job_cards  BEFORE UPDATE ON job_cards  FOR EACH ROW EXECUTE FUNCTION _updated_at(); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TRIGGER t_invoices   BEFORE UPDATE ON invoices   FOR EACH ROW EXECUTE FUNCTION _updated_at(); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Indexes for fast queries
CREATE INDEX IF NOT EXISTS idx_v_cust   ON vehicles(customer_id);
CREATE INDEX IF NOT EXISTS idx_jc_stat  ON job_cards(status);
CREATE INDEX IF NOT EXISTS idx_jc_cust  ON job_cards(customer_id);
CREATE INDEX IF NOT EXISTS idx_inv_type ON invoices(type);
CREATE INDEX IF NOT EXISTS idx_inv_pay  ON invoices(payment_status);
CREATE INDEX IF NOT EXISTS idx_inv_date ON invoices(date DESC);
CREATE INDEX IF NOT EXISTS idx_inv_cust ON invoices(customer_id);
CREATE INDEX IF NOT EXISTS idx_p_cat    ON parts(category);

-- Disable RLS (single-workshop app with anon key)
ALTER TABLE settings  DISABLE ROW LEVEL SECURITY;
ALTER TABLE customers DISABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles  DISABLE ROW LEVEL SECURITY;
ALTER TABLE parts     DISABLE ROW LEVEL SECURITY;
ALTER TABLE job_cards DISABLE ROW LEVEL SECURITY;
ALTER TABLE invoices  DISABLE ROW LEVEL SECURITY;

-- Done!
