# grandata

# Spark Project with Jupyter and Poetry

This project provides a Spark environment configured with Docker and a virtual environment managed by Poetry. It also includes Jupyter Notebook for easy development and experimentation.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Poetry](https://python-poetry.org/docs/#installation)

## Usage Instructions

### Project Setup

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Install dependencies with Poetry**:

   ```bash
   poetry install
   ```

### Start the Jupiter Notebook

To start the Jupyter Notebook, use the following command to use the virtual environment:

```bash
poetry shell
```

Then, use the following command to start the Jupyter Notebook:

```bash
make start-jupyter
```

To install the kernel in Jupyter, use the following command:

```bash
make install-kernel
```
