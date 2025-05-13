# Introduction to observability

This is the repo for a introduction to observability workshop. The course is designed to help you understand the basics of observability and how to implement it in your applications.

The course covers the following topics:

- What, why and how about observability?
- What is the azure monitor stack
- Collecting telemetry and logs from azure services
- Collecting telemetry from your applications
- introduction to KQL and azure workbooks

Start with the 00/introduction notebook.

## Notebook flow

| Step | Notebook | Purpose |
|------|----------|---------|
| 00   | 00-Introduction.ipynb               | Why observability |
| 01   | 01-Azure-monitor-resources.ipynb    | Deploy core resources |
| 02   | 02-Monitoring-Azure-Services.ipynb  | Enable service logs |
| 03   | 03-opentelemetry-basics.ipynb       | SDK & collector |
| 04   | 04-llm-webapp.ipynb                 | Instrument a Chainlit LLM app |
| 05   | 05-KQL and Dashboards in azure.ipynb| Query & visualize |

## Quick start

```bash
# 1. create env & install
python -m venv .venv && .\.venv\Scripts\activate
pip install -r requirements.txt
# 2. copy sample env
copy .env.sample .env
```
