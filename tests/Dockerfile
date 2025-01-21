FROM mcr.microsoft.com/powershell:latest

WORKDIR /app

COPY tests/RunTests.ps1 .

CMD ["pwsh", "-File", "RunTests.ps1"]