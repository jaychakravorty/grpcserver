#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1909 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-1909 AS build
WORKDIR /src
COPY ["GrpcServer.csproj", "./"]
RUN dotnet restore "./GrpcServer.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "GrpcServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GrpcServer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GrpcServer.dll"]
