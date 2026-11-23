# CTG Blood Bank
Responsive donor and blood request management interface built with React, TypeScript, Vite and Supabase.

## Run locally
- `npm install`
- Copy `.env.example` to `.env` and fill Supabase URL + publishable key.
- `npm run dev`
- Build: `npm run build`

Modules: splash/welcome/auth, dashboard, donor registration and filters, blood request/emergency, request status, inventory cards, activity chart, screening/collection/testing/processing/compatibility/authorized issue/transfusion logs, Excel and PDF export.
Clinical records are workflow tracking only. Actual screening, testing, compatibility and transfusion decisions require qualified professionals and approved protocols.


## Supabase workflow schema

Apply SQL files in the Supabase SQL Editor in this order:
1. `supabase/schema.sql`
2. `supabase/workflow_tables.sql`

Set the Vite environment variables in `.env` using `.env.example`. The browser app only uses the Supabase publishable/anon key; never add a service-role key to frontend environment variables.

**Production caution:** this project is an operational tracking prototype. Do not use it to make clinical eligibility, blood compatibility, laboratory, issue, or transfusion decisions. Qualified blood-bank staff must follow validated procedures. Review RLS policies and donor-contact privacy before deployment.
