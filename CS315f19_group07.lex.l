/* souffle.l */
%option yylineno
lowercase      [a-z]
uppercase      [A-Z]
digit          [0-9]
alphabetic     [A-Za-z_]
alphanumeric   ({alphabetic}|{digit})
%%
go             return (GO);
stop           return (STOP);
readTemp       return (READ_TEMP);
readHum        return (READ_HUM);
readAirPress   return (READ_AIR_PRESS);
readAirQuality return (READ_AIR_QUALITY);
readLight      return (READ_LIGHT);
readSoundLevel return (READ_SOUND_LEVEL);
send           return (SEND);
receive        return (RECEIVE);
turnOnSwitch   return (TURN_ON_SWITCH);
turnOffSwitch  return (TURN_OFF_SWITCH);
connect        return (CONNECT);

string         return (STRING);
int            return (INTEGER);
double         return (DOUBLE);
bool           return (BOOLEAN);
conn           return (CONN);
time           return (TIME);
void           return (VOID);
url            return (URL);

loop           return (LOOP);
from           return (FROM);
to             return (TO);
by             return (BY);
until          return (UNTIL);
print          return (PRINT);
scan           return (SCAN);
if             return (IF);
elif           return (ELIF);
else           return (ELSE);
return         return (RETURN);

\+             return (PLUS_SIGN);
\-             return (MINUS_SIGN);
\*             return (MULT_SIGN);
\/             return (DIV_SIGN);
\%             return (MOD_SIGN);
\+\+           return (INCREMENT_OP);
\-\-           return (DECREMENT_OP);

\|             return (OR);
\&             return (AND);

\<\-           return (ASSIGMENT_OP);
\=\=           return (EQUAL_COMP);
\<             return (LESS_COMP);
\>             return (GREATER_COMP);
\<\=           return (LESS_EQUAL_COMP);
\>\=           return (GREATER_EQUAL_COMP);
\!\=           return (NON_EQUAL_COMP);

\;             return (SEMICOLON);
\.             return (DOT);
\,             return (COMMA);

(\*\#)             return (END_BLOCK_COMMENT);
(\#\*)[^(\*\#)]*   return (BLOCK_COMMENT);
(\#)(.)*\n           return (SINGLE_COMMENT);

\[                 return (LEFT_SQ_BRAC);
\]                 return (RIGHT_SQ_BRAC);
\{                 return (LEFT_CR_BRAC);
\}                 return (RIGHT_CR_BRAC);
\(                 return (LEFT_PARAN);
\)                 return (RIGHT_PARAN);

true           return (TRUE);
false          return (FALSE);

\"(.)*\"                       return (STRING_CONST);
{lowercase}+{alphanumeric}*    return (IDENTIFIER);
{digit}+                       return (INTEGER_CONST);
{digit}*(\.)?{digit}+          return (DOUBLE_CONST);
http:\/\/[^\;\)]*                  return (URL_CONST);
.                              ;
\n                             ;

%%
int yywrap(){
   return 1;
}
