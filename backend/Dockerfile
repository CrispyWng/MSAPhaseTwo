# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
EXPOSE 80
WORKDIR /app
    
# Copy csproj and restore as distinct layers
COPY ./MSA.BackendAPI ./
RUN dotnet restore
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app .
ENTRYPOINT ["dotnet", "MSA.BackendAPI-assembly.dll"]
