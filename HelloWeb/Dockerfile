FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
RUN  apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["HelloWeb/HelloWeb.csproj", "HelloWeb/"]
RUN dotnet restore "./HelloWeb/HelloWeb.csproj"
COPY . .
WORKDIR "/src/HelloWeb"
RUN dotnet build "./HelloWeb.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./HelloWeb.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:80;http://+:5001
ARG ASPNETCORE_ENVIRONMENT
ENV ASPNETCORE_ENVIRONMENT=${ASPNETCORE_ENVIRONMENT:-Development}
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:5001/healthz || exit 1
ENTRYPOINT ["dotnet", "HelloWeb.dll"]