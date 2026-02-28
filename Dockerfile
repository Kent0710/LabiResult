FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first (better for caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code and the images folder into the container
COPY main.py .
COPY images ./images

# Run your script when the container starts
CMD ["python", "main.py"]