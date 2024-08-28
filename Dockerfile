ARG ERIC_ENM_SLES_EAP7_IMAGE_NAME=eric-enm-sles-eap7
ARG ERIC_ENM_SLES_EAP7_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-enm
ARG ERIC_ENM_SLES_EAP7_IMAGE_TAG=1.64.0-30

FROM ${ERIC_ENM_SLES_EAP7_IMAGE_REPO}/${ERIC_ENM_SLES_EAP7_IMAGE_NAME}:${ERIC_ENM_SLES_EAP7_IMAGE_TAG}

ARG BUILD_DATE=unspecified
ARG IMAGE_BUILD_VERSION=unspecified
ARG GIT_COMMIT=unspecified
ARG ISO_VERSION=unspecified
ARG RSTATE=unspecified

LABEL \
com.ericsson.product-number="CXC Placeholder" \
com.ericsson.product-revision=$RSTATE \
enm_iso_version=$ISO_VERSION \
org.label-schema.name="ENM MSMPLANE SG" \
org.label-schema.build-date=$BUILD_DATE \
org.label-schema.vcs-ref=$GIT_COMMIT \
org.label-schema.vendor="Ericsson" \
org.label-schema.version=$IMAGE_BUILD_VERSION \
org.label-schema.schema-version="1.0.0-rc1"

COPY image_content/*.rpm /var/tmp/
RUN zypper install -y ERICserviceframework4_CXP9037454 \
        ERICpib2_CXP9037459 \
	ERICserviceframeworkmodule4_CXP9037453 \
	ERICmodelserviceapi_CXP9030594 \
	ERICmodelservice_CXP9030595 && \
	rpm -ivh /var/tmp/ERICenmsgmsmplane_CXP9043936*.rpm --nodeps --noscripts && \
	zypper clean -a
	
ENV ENM_JBOSS_SDK_CLUSTER_ID="msmplane" \
    ENM_JBOSS_BIND_ADDRESS="0.0.0.0" \
    GLOBAL_CONFIG="/gp/global.properties" \
    JBOSS_CONF="/ericsson/3pp/jboss/app-server.conf"

EXPOSE 4335
