//
//  AlgorithmViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/3/1.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "AlgorithmViewController.h"

typedef struct Node{
    int num;
    struct Node *next;
}Node;

typedef struct NodeTree{
    int num;
    struct NodeTree *left;
    struct NodeTree *right;
}NodeTree;

@interface AlgorithmViewController ()

@end

@implementation AlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    [self setNavWithTitle:@"算法测试" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
//    testRotateStr();
    
//    char s[] = "abcd";
//    putAllData(s, 0, strlen(s)-1);
//    while (getNextStr(s,strlen(s)));
    
//    int a[] = {34,56,12,3,53,26,89,10,20,45,67,23,24,99,678,34,110,26,486,75};
//    showPreMax(a, sizeof(a)/sizeof(int), 6);
//    for(int i=0;i<6;i++)
//    {
//        NSLog(@"%d",a[i]);
//    }
    
//    int num = [self addFun:4];
    
//    NSLog(@">>>>>>>>>>%d",num);
    
//    [self testLink];

//    [self testContainStr];
    
//    [self checkNumForStr:@"eedeesstspupp"];
    
//    NSLog(@">>>>>%f",[self strToFloat:@"222.234354545454545454545"]);
    
//    [self testNodeTree];
    
    [self testArrToSum];
}

- (void)testArrToSum
{
    int a[] = {3,6,8,2,4,9,1,5,7};
    int n = sizeof(a)/sizeof(int);
    for(int i=0;i<n-1;i++)
    {
        for(int j=i+1;j<n;j++)
        {
            if(a[i]>a[j])
            {
                int t = a[i];
                a[i] = a[j];
                a[j] = t;
            }
        }
    }
    
    for(int i=0;i<n-2;i++)
    {
        for(int j=i+1;j<n-1;j++)
        {
            for(int k=j+1;k<n;k++)
            {
                int sum = a[i]+a[j]+a[k];
                if(sum==13)
                {
                    NSLog(@"%d,%d,%d",a[i],a[j],a[k]);
                }
                else if(sum>13)
                    break;
            }
        }
    }
}

//float字符串转float数值
- (float)strToFloat:(NSString *)str
{
    NSArray *numArr = [str componentsSeparatedByString:@"."];
    if(numArr.count!=2)
        return 0;
    NSString *shiStr = [numArr objectAtIndex:0];
    NSString *moStr = [numArr objectAtIndex:1];
    float num = 0,xiaoNum = 0;
    for(int i=0;i<shiStr.length;i++)
    {
        char c = [shiStr characterAtIndex:i];
        if(c<'0'&&c>'9')
            continue;
        num = (c-'0') + num*10;
    }
    int nW = 0;
    //小数位
    for(int i=0;i<moStr.length;i++)
    {
        char c = [moStr characterAtIndex:i];
        if(c<'0'&&c>'9')
            continue;
        nW++;
        xiaoNum = (c-'0') + xiaoNum*10;
    }
    if(xiaoNum>0)
    {
        num += xiaoNum/pow(10, nW);
    }
//    if(num>FLT_MAX||num<FLT_MIN)
//        return 0;
    return num;
}

//统计字符个数
- (void)checkNumForStr:(NSString *)str
{
    NSMutableDictionary *mulDic = [NSMutableDictionary new];
    for(int i=0;i<str.length;i++)
    {
        char s = [str characterAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%c",s];
        //获取个数
        int num = [[mulDic objectForKey:key] intValue];
        num++;
        [mulDic setObject:@(num) forKey:key];
    }
    NSString *outStr = @"";
    for(NSString *key in mulDic.allKeys)
    {
        outStr = [NSString stringWithFormat:@"%@%@%d",outStr,key,[mulDic[key] intValue]];
    }
    
    NSLog(outStr);
}

- (void)testNodeTree
{
    NodeTree *root;
    root = createNodeTree(root);
    
    preSearch(root);
}
//创建二叉树
NodeTree *createNodeTree(NodeTree *root)
{
    char ch;
//    scanf("%c", &ch);
//    setbuf(stdin, NULL);
//    scanf("%[^\n]%*c",&ch);
//    printf("%d,",ch);
    if(ch == '#')
    {
        return NULL;
    }
    else
    {
        root = (NodeTree *)malloc(sizeof(NodeTree));
        root->num = ch;
        root->left = createNodeTree(root->left);
        root->right = createNodeTree(root->right);
    }

    return root;
}
//先序遍历
void preSearch(NodeTree *root)
{
    if(root!=NULL)
    {
        printf("%d,",root->num);
        preSearch(root->left);
        preSearch(root->right);
    }
}
//判断是否为对称的二叉树
bool isSTree(NodeTree *root)
{
    if(!root)
        return true;
    return isSubSTree(root->left, root->right);
}

bool isSubSTree(NodeTree *left,NodeTree *right)
{
    if(!left&&!right)
        return true;
    if(!left||!right)
        return false;
    if(left->num==right->num)
        return (isSubSTree(left->left, right->right)&&isSubSTree(left->right, right->left));
    return false;
}

//给定两个分别由字母组成的字符串A和字符串B，字符串B的长度比字符串A短。请问，如何最快地判断字符串B中所有字母是否都在字符串A里？
- (void)testContainStr
{
    char *s1 = "abcd";
    char *s2 = "dd";
    NSLog(@">>>>%d",isContainStr(s1, s2));
}
bool isContainStr(char *str1,char *str2)
{
    uint32_t num = 0;
    for(int i=0;i<strlen(str1);i++)
    {
        int n = str1[i] - 'a';
        num = num|(1<<n);
    }
    for(int i=0;i<strlen(str2);i++)
    {
        int n = str2[i] - 'a';
        if(!(num&(1<<n)))
            return false;
    }
    return true;
}

//链表翻转。给出一个链表和一个数k，比如，链表为1→2→3→4→5→6，k=2，则翻转后2→1→6→5→4→3，若k=3，翻转后3→2→1→6→5→4，若k=4，翻转后4→3→2→1→6→5，用程序实现
- (void)testLink
{
    int arr[] = {1,2,3,4,5,6,7,8,9};
    Node *head = createNode(arr, sizeof(arr)/sizeof(int));
    showNode(head);
    
    head = testLink1(head, 6);
//    head = changeNode(head);
    showNode(head);
}

Node *testLink1(Node *head,int k)
{
    Node *link1 = head;
    Node *link2 = head;
    Node *pre = head;
    for(int i=0;i<k;i++)
    {
        if(head==NULL)
            break;
        pre = head;
        head = head->next;
    }
    pre->next = NULL;
    link2 = head;
    
    link1 = changeNode(link1);
    link2 = changeNode(link2);
    head = link1;
    while (link1->next) {
        link1 = link1->next;
    }
    
    link1->next = link2;
    
    return head;
}
//生成链表
Node *createNode(int arr[],int n)
{
    Node *head = (Node *)malloc(sizeof(Node));
    head->next = NULL;
    Node *s = head;
    for(int i=0;i<n;i++)
    {
        Node *tmpN = (Node *)malloc(sizeof(Node));
        tmpN->num = arr[i];
        tmpN->next = s->next;
        s->next = tmpN;
        s = tmpN;
    }
    return head->next;
}
//进行链表反转
Node *changeNode(Node *head)
{
    //使用头插法反转链表
    Node *stmp = (Node *)malloc(sizeof(head));
    stmp->next = NULL;
    Node *preHead = head;
    while (preHead) {
        Node *current = preHead;
        preHead = preHead->next;
        //头插法
        current->next = stmp->next;
        stmp->next = current;
    }
    
    return stmp->next;
}
//展示链表
void showNode(Node *head)
{
    NSString *str = @"";
    while (head) {
        str = [NSString stringWithFormat:@"%@%d,",str,head->num];
        head = head->next;
    }
    NSLog(str);
}

//递归1加到n
- (int)addFun:(int)n
{
    if(n<=0)
        return 0;
    return n+[self addFun:n-1];
}

//输出最大的多少个数
void showPreMax(int *a,int n,int num)
{
    for(int i=0;i<n-1;i++)
    {
        if(i==num)
            break;
        for(int j=i+1;j<n;j++)
        {
            if(a[i]<a[j])
            {
                int t = a[i];
                a[i] = a[j];
                a[j] = t;
            }
        }
    }
}

//调换字符
void testRotateStr()
{
    char s[] = "I am a student.";
//    LeftRotateString(s, strlen(s), 3);
    rotateWord(s, strlen(s));
    NSLog(@"%s",s);
}
void changeStr(char *a,int from,int to)
{
    while (from<to) {
        char t = a[from];
        a[from] = a[to];
        a[to] = t;
        from++;
        to--;
    }
}
void LeftRotateString(char* s,int n,int m)
{
    //移动头部
//    changeStr(s, 0, m-1);
//    changeStr(s, m, n-1);
//    changeStr(s, 0, n-1);
    //移动尾部的
    int k = n-m;
    changeStr(s, 0, k-1);
    changeStr(s, k, n-1);
    changeStr(s, 0, n-1);
}

void rotateWord(char *s,int n)
{
    int from = 0,to = 0;
    for(int i=0;i<n;i++)
    {
        if(s[i]==' '||i==n-1)
        {
            if(i==n-1)
                to = i;
            else
                to = i-1;
            changeStr(s, from, to);
            from = i+1;
        }
      
    }
    
    changeStr(s, 0, n-1);
}

//交换
void getExchange(char *s,int src,int dec)
{
    char tmp = s[src];
    s[src] = s[dec];
    s[dec] = tmp;
}
//输出所有的情况
void putAllData(char *s,int from,int to)
{
    if(from==to)
    {
        //输出
        NSLog(@"%s",s);
    }
    else
    {
        for(int j=from;j<=to;j++)
        {
            //换一个作为起点
            getExchange(s, from, j);
            putAllData(s, from+1, to);
            //换回来
            getExchange(s, from, j);
        }
    }
}

//字符串从小便大的一个过程如123-->321 这样所有的组合都有（字典序排序）
//找出当前字符串的下一个
bool getNextStr(char *s,int n)
{
    //后往前找，找到小于后面的数的位置
    int k = n-2;
    for(;k>=0&&s[k]>=s[k+1];k--);
    if(k<0)
        return false;       //已经是最后的字符串了
    //找出交换的位置
    int j = n-1;
    for(;j>k&&s[j]<=s[k];j--);
    if(j<=k)
        return false;
    
    //交换
    getExchange(s, k, j);
    //k位置后的所有倒转
    changeStr(s, k+1, n-1);
    NSLog(@"%s",s);
    return true;
}

//一些排序
//快排
int partion(int a[],int low,int high)
{
    int k = a[low];
    while (low<high) {
        while(low<high&&a[high]>=k) high--;
        int t = a[low];
        a[low] = a[high];
        a[high] = t;
        while(low<high&&a[low]<=k) low++;
        t = a[low];
        a[low] = a[high];
        a[high] = t;
    }
    
    return low;
}

void quickSort(int a[],int low,int high)
{
    if(low<high)
    {
        int mid = partion(a, low, high);
        quickSort(a, low, mid-1);
        quickSort(a, mid+1, high);
    }
}

//直接插入
void insertSort(int a[],int n)
{
    for(int i=1;i<n;i++)
    {
        int j = i - 1;
        int k = a[i];
        while (a[j]>k) {
            a[j+1] = a[j];
            j = j - 1;
            if(j<0)
                break;
        }
        a[j+1] = k;
    }
}

//二分
int binSort(int a[],int low,int high,int find)
{
    while (low<high) {
        int mid = low+(high-low)/2;
        if(a[mid]>find)
            high = mid - 1;
        else if(a[mid]<find)
            low = mid + 1;
        else
            return mid;
    }
    
    return low;
}
@end
