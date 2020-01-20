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

const userNames = ['Bob', 'Alice', 'John', 'Mike', 'Joe', 'Bruce'];
const text = ['a thing', 'another thing', 'not useful', 'very useful', 'broken', 'cool'];
const types = ['public', 'private'];
const messages = [];
for (let i = 0; i < 50; i++) {
    messages.push({
        id: i + 1,
        sender: userNames[getRandomInt(0, userNames.length)],
        receiver: userNames[getRandomInt(0, userNames.length)],
        text: text[getRandomInt(0, text.length)],
        date: i + 1,
        type: types[getRandomInt(0, types.length)]
    });
}

const router = new Router();
router.get('/public', ctx => {
    ctx.response.body = messages.filter(message => message.type === types[0]);
    ctx.response.status = 200;
});

router.get('/users', ctx => {
    ctx.response.body = userNames;
    ctx.response.status = 200;
});

router.get('/sender/:user', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    const user = headers.user;
    // console.log("genre: " + JSON.stringify(genre));
    ctx.response.body = messages.filter(message => message.sender == user && message.type === types[0]);
    // console.log("body: " + JSON.stringify(ctx.response.body));
    ctx.response.status = 200;
});


router.get('/receiver/:user', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    const user = headers.user;
    // console.log("genre: " + JSON.stringify(genre));
    ctx.response.body = messages.filter(message => message.receiver == user && message.type === types[0]);
    // console.log("body: " + JSON.stringify(ctx.response.body));
    ctx.response.status = 200;
});


router.get('/private/:user', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    const user = headers.user;
    // console.log("genre: " + JSON.stringify(genre));
    ctx.response.body = messages.filter(message => (message.receiver == user || message.sender == user) && message.type === types[1]);
    // console.log("body: " + JSON.stringify(ctx.response.body));
    ctx.response.status = 200;
});

router.post('/message', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.request.body;
    // console.log("body: " + JSON.stringify(headers));
    const sender = headers.sender;
    const receiver = headers.receiver;
    const text = headers.text;
    const type = headers.type;
    if (typeof sender !== 'undefined' && typeof receiver !== 'undefined' && typeof text !== 'undefined' && typeof type !== 'undefined') {
        let maxId = Math.max.apply(Math, messages.map(function (message) {
            return message.id;
        })) + 1;
        let message = {
            id: maxId,
            sender,
            receiver,
            text,
            date: maxId,
            type
        };
        messages.push(message);
        ctx.response.body = message;
        ctx.response.status = 200;
    } else {
        console.log("Missing or invalid: sender, receiver, text or type!");
        ctx.response.body = {text: 'Missing or invalid: sender, receiver, text or type!'};
        ctx.response.status = 404;
    }
});

router.del('/message/:id', ctx => {
    // console.log("ctx: " + JSON.stringify(ctx));
    const headers = ctx.params;
    // console.log("body: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = messages.findIndex(message => message.id == id);
        if (index === -1) {
            console.log("No message with id: " + id);
            ctx.response.body = {text: 'Invalid message id'};
            ctx.response.status = 404;
        } else {
            let message = messages[index];
            messages.splice(index, 1);
            ctx.response.body = message;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = {text: 'Id missing or invalid'};
        ctx.response.status = 404;
    }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2101);
