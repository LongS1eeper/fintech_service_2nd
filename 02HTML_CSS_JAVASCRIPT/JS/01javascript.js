// 웹브라우저 콘솔에 id title을 갖는 태그를 찾아서 출력
const title = document.querySelector("#title");
// const: 변하지 않는 자료, let: 자료를 변경 가능, var: 자료 변경 가능 (데이터 타입 3가지)    
console.log(title);


// 링크 클릭 후 로그 기록
// 링크 클릭 이벤트 연결하기
const link = document.querySelector("#link")
link.addEventListener("click", ()=> {
    console.log("링크를 클릭했습니다.");
});
// 링크를 클릭해도 링크가 작동되지 않고 consol.log만 기록되도록록
const nolink = document.querySelector("#no-link");
nolink.addEventListener("click", (e) => {  
    e.preventDefault(); // 링크 이동 방지
    console.log("이 링크는 이동하지 않습니다.");
});



// 특정 영역에 마우스 포인터를 위치할 때 동작하는 호버 마우스 이벤트 연결 
// HTML 요소에 마우스 이벤트: 올렸을 때
const box = document.querySelector("#box")
box.addEventListener("mouseenter", ()=>{
    box.style.backgroundColor = "hotpink";
});
// HTML 요소에 마우스 이벤트: 내렸을 때
box.addEventListener("mouseleave", ()=>{
    box.style.backgroundColor = "aqua";
});


// 반복되는 요소에 이벤트 한꺼번에 연결하기
const list = document.querySelectorAll(".list li")
console.log(list);
for (let el of list){
    el.addEventListener("click", e=>{
        e.preventDefault();
        console.log(e.currentTarget.innerText);
    });
}


// 클릭 이벤트가 발생할 때 숫자 증가, 감소하기
const btnPlus = document.querySelector(".btnPlus");
const btnMinus = document.querySelector(".btnMinus");
let num = 0;  // 제어할 숫자 값을 0으로 초기화

// btnPlus를 클릭할 때
btnPlus.addEventListener("click", e=>{
    e.preventDefault();
    num++;  // num 값을 1씩 증가
    console.log(num);
})

// btnMinus를 클릭할 때
btnMinus.addEventListener("click", e=>{
    e.preventDefault();
    num--;  // num 값을 1씩 감소
    console.log(num);
})



// 버튼을 클릭하면 좌우로 회전하는 박스 만들기
const btnLeft = document.querySelector(".btnLeft");
const btnRight = document.querySelector(".btnRight");
const box2 = document.querySelector("#box2");
const deg = 45;      // 회전할 각도
let num2 = 0;        // 증가시킬 값을 0으로 초기화


// btnLeft를 클릭할 때
btnLeft.addEventListener("click", e=>{
    e.preventDefault();
    num2--;
    console.log(`num2: ${num2}`)      // 파이썬에서 f string과 동일하게 작용: `${내용}`
    box2.style.transform = `rotate(${num2 * deg}deg)`;
});
// btnRight를 클릭할 때
btnRight.addEventListener("click", e=>{
    e.preventDefault();
    num2++;
    console.log(`num2: ${num2}`)      // 파이썬에서 f string과 동일하게 작용: `${내용}`
    box2.style.transform = `rotate(${num2 * deg}deg)`;
});