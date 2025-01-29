# use an official Node.js runtime as a parent image
FROM node:22-alpine

# set timezone
ENV TZ=${TZ:-UTC}
RUN apk add --no-cache tzdata

# set the working directory in the container
WORKDIR /home/node

# copy the npm dependencies file
COPY package.json .

# install dependencies and packages specified in package.json
RUN apk add --no-cache --virtual .gyp \
        python3 \
        make \
        g++ \
    && npm install \
    && apk del .gyp

# Create the cache directory
RUN mkdir -p ./cache && chown node:node ./cache
# create the cache directory and reset permissions
RUN mkdir -p ./cache && chown -R node:node /home/node

# copy the relevant files to the container at the workdir
COPY --chown=node:node crontab *.js* ./

# copy entrypoint
COPY entrypoint.sh /sbin

# define environment variables
ENV NODE_ENV=production

# run entrypoint script when the container launches
ENTRYPOINT ["/sbin/entrypoint.sh"]
