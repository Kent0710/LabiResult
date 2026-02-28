# 🩸 Lab Report Analyzer

A desktop GUI application that extracts text from lab report images using OCR ([Docling](https://github.com/DS4SD/docling)), analyzes the results with a local LLM ([Llama 3 via Ollama](https://ollama.com)), and optionally emails a formatted summary — all from a single window.

---

## Features

- **OCR Extraction** — Converts lab report images (PNG, JPG, WEBP, PDF) to structured text using Docling with confidence scoring.
- **AI Analysis** — Sends extracted text to Llama 3 (8B) running locally via Ollama for a plain-language health summary.
- **Out-of-Range Detection** — Highlights abnormal values with their normal ranges.
- **Email Reports** — Send the analysis to any Gmail address using an App Password.
- **Dark-Themed GUI** — Built with [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter) for a modern look.
- **VRAM Management** — Automatically cleans up OCR resources before running the LLM to avoid CUDA out-of-memory errors.

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **Python** | 3.11+ |
| **Ollama** | Installed and running (`ollama serve`) |
| **Llama 3 model** | Pulled locally: `ollama pull llama3:8b` |
| **GPU (recommended)** | NVIDIA GPU with CUDA support for faster inference |
| **Gmail App Password** | Required only if you want to email results ([how to create one](https://support.google.com/accounts/answer/185833)) |

---

## Quick Start

### Option A — Run Locally

```bash
# 1. Clone the repository
git clone https://github.com/your-username/labiresult.git
cd labiresult

# 2. Create and activate a virtual environment
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Make sure Ollama is running and the model is available
ollama serve          # in a separate terminal
ollama pull llama3:8b

# 5. Launch the app
python main.py
```

### Option B — Run with Docker

> **Note:** The Dockerfile builds a headless image suitable for CI or server-side batch processing. For the full GUI experience, run locally (Option A). You will also need Ollama accessible from inside the container.

```bash
# 1. Build the image
docker build -t labiresult .

# 2. Run with a lab report image mounted in
#    Replace <path-to-image> with the actual file on your host
docker run --rm \
  -v <path-to-image>:/app/images/report.png \
  labiresult \
  python main.py /app/images/report.png
```

To connect to an Ollama instance running on the host:

```bash
# Linux / macOS
docker run --rm --network host \
  -v <path-to-image>:/app/images/report.png \
  labiresult python main.py /app/images/report.png

# Windows (Docker Desktop) — use host.docker.internal
docker run --rm \
  -e OLLAMA_HOST=http://host.docker.internal:11434 \
  -v <path-to-image>:/app/images/report.png \
  labiresult python main.py /app/images/report.png
```

---

## Usage

1. **Browse** — Click the Browse button and select a lab report image.
2. **Analyze** — Click **▶ Analyze Report**. The app will:
   - Run OCR and display a confidence banner (green = high confidence, amber = warnings).
   - Send the extracted text to Llama 3 for analysis.
   - Display a formatted result with section headers for out-of-range values, health summary, recommendations, and lifestyle advice.
   - Save the raw analysis to `analysis.txt`.
3. **Email (optional)** — Fill in your Gmail address and App Password, then click **📧 Send Email**. If no recipient is specified, the email is sent to yourself.

---

## Project Structure

```
labiresult/
├── main.py              # Application entry point (GUI + core logic)
├── requirements.txt     # Pinned Python dependencies
├── Dockerfile           # Container build file
├── .dockerignore        # Files excluded from Docker context
├── .gitignore           # Files excluded from Git
├── images/              # Sample lab report images
│   └── sample-lab-report-gemini-generated.png
├── LICENSE              # MIT License
└── README.md            # This file
```

---

## Disclaimer

> ⚕️ This tool is for **informational purposes only**. It is **not** a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider for any medical concerns.

---

## License

This project is licensed under the [MIT License](LICENSE).
