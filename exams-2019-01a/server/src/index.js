const koa = require('koa');
const app = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({server});
const Router = require('koa-router');
const cors = require('koa-cors');
const bodyParser = require('koa-bodyparser');
const convert = require('koa-convert');

app.use(bodyParser());
app.use(convert(cors()));
app.use(async (ctx, next) => {
    const start = new Date();
    await next();
    const ms = new Date() - start;
    console.log(`${ctx.method} ${ctx.url} ${ctx.response.status} - ${ms}ms`);
});

const getRandomInt = (min, max) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
};

const phoneNames = ['The good', 'The bad', 'The ugly', 'Old', 'New', 'Blue'];
const manufacturers = ['Apple', 'Google', 'Samsung', 'LG', 'HTC', 'Motorola', 'Nokia'];
const phones = [];
for (let i = 0; i < 50; i++) {
    phones.push({
        id: i + 1,
        name: phoneNames[getRandomInt(0, phoneNames.length)],
        size: getRandomInt(4, 7),
        manufacturer: manufacturers[getRandomInt(0, manufacturers.length)],
        quantity: getRandomInt(5, 10),
        reserved: getRandomInt(0, 3)
    });
}

const router = new Router();
router.get('/phones', ctx => {
    ctx.response.body = phones;
    ctx.response.status = 200;
});

router.post('/reserve', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = phones.findIndex(phone => phone.id == id && phone.reserved <= phone.quantity);
        if (index === -1) {
            console.log("Phone not available!");
            ctx.response.body = {text: 'Phone not available!'};
            ctx.response.status = 404;
        } else {
            let phone = phones[index];
            phone.reserved++;
            ctx.response.body = phone;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = {text: 'Missing or invalid: id!'};
        ctx.response.status = 404;
    }
});

router.post('/cancel', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = phones.findIndex(phone => phone.id == id && phone.reserved > 0);
        if (index === -1) {
            console.log("Phone not available!");
            ctx.response.body = {text: 'Phone not available!'};
            ctx.response.status = 404;
        } else {
            let phone = phones[index];
            phone.reserved--;
            ctx.response.body = phone;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = {text: 'Missing or invalid: id!'};
        ctx.response.status = 404;
    }
});

router.post('/buy', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = phones.findIndex(phone => phone.id == id && phone.quantity > phone.reserved && phone.quantity > 0);
        if (index === -1) {
            console.log("Phone not available!");
            ctx.response.body = {text: 'Phone not available!'};
            ctx.response.status = 404;
        } else {
            let phone = phones[index];
            phone.quantity--;
            ctx.response.body = phone;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = {text: 'Missing or invalid: id!'};
        ctx.response.status = 404;
    }
});


const broadcast = (data) =>
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data));
        }
    });

router.post('/phone', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const name = headers.name;
    const size = headers.size;
    const manufacturer = headers.manufacturer;
    const quantity = headers.quantity;
    if (typeof name !== 'undefined' && typeof size !== 'undefined' && typeof manufacturer !== 'undefined' && typeof quantity !== 'undefined') {
        const index = phones.findIndex(phone => phone.name == name && phone.manufacturer == manufacturer && phone.size == size);
        if (index !== -1) {
            console.log("Phone already exists! Updating quantity");
            let phone = phones[index];
            phone.quantity += quantity;
            ctx.response.body = phone;
            ctx.response.status = 404;
        } else {
            let maxId = Math.max.apply(Math, phones.map(function (phone) {
                return phone.id;
            })) + 1;
            let phone = {
                id: maxId,
                name,
                size,
                manufacturer,
                quantity,
                reserved: 0
            };
            phones.push(phone);
            ctx.response.body = phone;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: name, size, manufacturer or quantity!");
        ctx.response.body = {text: 'Missing or invalid: name, size, manufacturer or quantity!'};
        ctx.response.status = 404;
    }
});

router.del('/phone/:id', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = phones.findIndex(phone => phone.id == id);
        if (index === -1) {
            console.log("No phone with id: " + id);
            ctx.response.body = {text: 'Invalid phone id'};
            ctx.response.status = 404;
        } else {
            let phone = phones[index];
            phones.splice(index, 1);
            ctx.response.body = phone;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = {text: 'Id missing or invalid'};
        ctx.response.status = 404;
    }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2001);
