# Data Analysis & Chart Bot

Upload a CSV or Excel file, ask a question about it, and view the analysis and
charts in the Streamlit interface. The app uses paths relative to its project
folder and does not require a machine-specific dataset location.

Chart selection follows explicitly requested chart types and can render multiple
Plotly charts for a single question. Hover tooltips expose chart details, and
sunburst charts highlight the highest-valued leaf segment.

## Set up on a new computer

Use Python 3.11 or newer. Open a terminal in the project folder and run:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
Copy-Item .env.example .env
streamlit run app.py
```

On macOS or Linux, activate the virtual environment with
`source .venv/bin/activate`, then install the same `requirements.txt` and run
`streamlit run app.py`.

Upload a CSV or Excel file in the sidebar. No local sample dataset or absolute
file path is required.

## Offline evaluation (no API key or runtime internet required)

Dependencies must be installed before going offline. Then edit the local `.env`
file and set:

```dotenv
API_KEY=
USE_MOCK=True
```

Start the app with `streamlit run app.py`. Mock Mode makes no model API calls;
it generates an executive-oriented analysis and supported charts locally from
the uploaded dataset. An empty `API_KEY` also enables Mock Mode automatically.

## Optional live API configuration

For live analysis, set `API_KEY` and optionally `MODEL_NAME` in `.env` or
Streamlit secrets. Requests always use OpenRouter at
`https://openrouter.ai/api/v1`; supported models are
`nvidia/nemotron-3.5-lightning` (default) and `cohere/north-mini-code`.
Unsupported model values use the default. Environment variables and `.env`
values take precedence over Streamlit secrets. Keep `.env` private; it is
excluded from the submission archive. If a live request fails, the app reports
the error and creates a local chart only when an exact chart type was requested.

For Streamlit secrets, add the same keys at the root of
`.streamlit/secrets.toml`:

```toml
API_KEY = "your-openrouter-api-key"
MODEL_NAME = "nvidia/nemotron-3.5-lightning"
USE_MOCK = false
```

## Lightweight submission

Run `.\package.ps1` in PowerShell to create a timestamped ZIP next to the
project. The archive contains the app, dependency list, environment template,
and README; it excludes `.env`, `.venv`, datasets, caches, and editor settings.
On the evaluation computer, extract the ZIP and follow the setup instructions
above.
