# Use official Python image
FROM python:3.9

# Set work directory
WORKDIR /app

# Copy files
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

# Expose port
EXPOSE 80

# Run the application
CMD ["python", "app.py"]
