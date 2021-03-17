# NonprofitInfo

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Data Files:

http://s3.amazonaws.com/irs-form-990/201132069349300318_public.xml
http://s3.amazonaws.com/irs-form-990/201612429349300846_public.xml
http://s3.amazonaws.com/irs-form-990/201521819349301247_public.xml
http://s3.amazonaws.com/irs-form-990/201641949349301259_public.xml
http://s3.amazonaws.com/irs-form-990/201921719349301032_public.xml
http://s3.amazonaws.com/irs-form-990/201831309349303578_public.xml
http://s3.amazonaws.com/irs-form-990/201823309349300127_public.xml
http://s3.amazonaws.com/irs-form-990/201401839349300020_public.xml
http://s3.amazonaws.com/irs-form-990/201522139349100402_public.xml
http://s3.amazonaws.com/irs-form-990/201831359349101003_public.xml

## API

Example API requests in [Insomnia](https://insomnia.rest/) format in: `insomnia_api_collection.json`

`GET /api/filings` - List all filings
`GET /api/filings/:id` - Get a specific filing
`GET /api/organizations` - List all organizations
`GET /api/organizations:/id` - Get a specific organization
`GET /api/awards` - List all awards
`GET /api/awards?state=CO` - Filter awards by state of recipient
`GET /api/awards/:id` - Get a specific award
