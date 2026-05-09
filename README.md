# Friends Automotive — Garage Management System

Industrial-grade garage management with **Supabase PostgreSQL** backend.
Accessible from **any device, anywhere** — phone, tablet, laptop.

---

## Setup (5 minutes)

### Step 1 — Create your free Supabase database

1. Go to **[supabase.com](https://supabase.com)** → Sign up free (no credit card needed)
2. Click **New project** → enter name `friends-automotive` and a password
3. Wait ~60 seconds for the project to initialize
4. Go to **SQL Editor** (left sidebar) → **New Query**
5. Copy the entire contents of `schema.sql` → Paste → click **Run**
6. You should see "Success. No rows returned"

### Step 2 — Get your API credentials

1. In Supabase dashboard → **Settings** (bottom left) → **API**
2. Copy your **Project URL** — looks like `https://abcdefgh.supabase.co`
3. Copy the **anon public** key — long JWT string starting with `eyJ...`

### Step 3 — Configure index.html

Open `index.html` and find these two lines near the top:

```javascript
window.FA_SUPABASE_URL = 'PASTE_SUPABASE_URL_HERE'
window.FA_SUPABASE_KEY = 'PASTE_SUPABASE_ANON_KEY_HERE'
```

Replace the placeholder values with your actual URL and key.

### Step 4 — Deploy to GitHub Pages

```bash
git init
git add .
git commit -m "Friends Automotive - initial deployment"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/friends-automotive.git
git push -u origin main
```

Then in GitHub:
1. Go to your repository → **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** | Folder: **/ (root)**
4. Click **Save**

Your app will be live at:
`https://YOUR_USERNAME.github.io/friends-automotive/`

---

## Accessing from Multiple Devices

- **Any browser** — open the GitHub Pages URL
- **Mobile** — same URL on Chrome/Safari; tap "Add to Home Screen" for app experience
- **All devices share the same database** — real-time sync via Supabase

---

## Features

| Module | Features |
|--------|----------|
| Dashboard | Revenue stats, open jobs, pending dues, low stock alerts |
| Job Cards | Create jobs, assign technicians, track status, generate invoices |
| Invoices | Estimate / Tax Invoice / Final Invoice with full print layout |
| Customers | GSTIN support, corporate/fleet accounts, full history |
| Vehicles | VIN, engine no., insurance expiry, odometer tracking |
| Inventory | HSN auto-fill, GST rates, stock alerts, rack location |
| Settings | Workshop details, bank info, invoice terms, statistics |

## Invoice Features
- Create from scratch OR generate from job card
- Every single field is editable
- SGV/Friends Automotive layout matching your existing invoice format
- Invoice number auto-format: FRA-DDMMYY-NNNN
- Amount in words (Indian format)
- GST breakup, bank details, 3 signature blocks
- Terms & conditions
- Print / Save as PDF

---

## Database (Supabase PostgreSQL)

| Table | Purpose |
|-------|---------|
| `settings` | Workshop details, bank info |
| `customers` | Customer records with GSTIN |
| `vehicles` | Vehicle details with VIN, engine no. |
| `parts` | Inventory with HSN codes and stock levels |
| `job_cards` | Work orders with parts/labour items (JSONB) |
| `invoices` | All estimates, invoices, final invoices |

**Free tier limits:** 500MB storage, unlimited API requests — handles thousands of records.

---

Built for Friends Automotive, Gurugram 🔧
