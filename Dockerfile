FROM hashicorp/terraform:1.3.6 AS terraform
FROM mcr.microsoft.com/azure-cli:latest
COPY --from=terraform /bin/terraform /bin/terraform

ENTRYPOINT ["bash"]