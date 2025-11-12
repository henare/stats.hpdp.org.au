# stats.hpdp.org

This repository has been archived. All content has been moved to **[henare/hpdp.org](https://github.com/henare/hpdp.org)**.

## History

This site contained the results of the [Harold Park Displaced Persons](https://www.hpdp.org/) pool
competition. It was originally [written in Cold Fusion](https://github.com/henare/stats.hpdp.org.au/commit/4864d2d485c919fde20cad11540b68ad43d0f413)
with a MySQL backend that had [the results of every game](https://github.com/henare/stats.hpdp.org.au/commit/625c7fddc54784bc48df5a9a99f10ad581c827f9)
in the pool comp, including the Nick Power Cup.

This was difficult to maintain and host so it was converted into a Jekyll site
hosted on Netlify. In this migration we focused on getting the NPC working
first as this is the only part of the HPDP pool comp that still operates. All
the historical data for the all the weeks are there but we haven't migrated
them.

## What happened?

The stats subdomain is now hosted as part of the main HPDP site. This repository now only contains a Netlify `_redirects` file that redirects all traffic to the new location at https://hpdp.org.au/stats/.

## Where to find the code

All the historical code and data for the Harold Park Displaced Persons pool competition results can now be found at:

**https://github.com/henare/hpdp.org**
