# CTG Blood Bank
Responsive donor and blood request management interface built with React, TypeScript, Vite and Supabase.

## Run locally
- `npm install`
- Copy `.env.example` to `.env` and fill Supabase URL + publishable key.
- `npm run dev`
- Build: `npm run build`

Modules: splash/welcome/auth, dashboard, donor registration and filters, blood request/emergency, request status, inventory cards, activity chart, screening/collection/testing/processing/compatibility/authorized issue/transfusion logs, Excel and PDF export.
Clinical records are workflow tracking only. Actual screening, testing, compatibility and transfusion decisions require qualified professionals and approved protocols.
