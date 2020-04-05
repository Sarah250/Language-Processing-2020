const fs = require("fs");
const ejs = require('ejs');

fs.readFile('./tp1_ex5_g19.json', (err, data ) => {
    if(err) throw err;

    let jsonData = JSON.parse(data);


    ejs.renderFile('./info.ejs', jsonData, (err, html) => {

        if(err) throw err;

        // console.log(html);

        fs.writeFileSync('tp1_ex5_g19.html', html)
    })
});