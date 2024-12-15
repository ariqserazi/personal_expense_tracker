from google.protobuf.internal import containers as _containers
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class ExpenseCategory(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    UNKNOWN: _ClassVar[ExpenseCategory]
    FOOD: _ClassVar[ExpenseCategory]
    TRANSPORT: _ClassVar[ExpenseCategory]
    SHOPPING: _ClassVar[ExpenseCategory]
    ENTERTAINMENT: _ClassVar[ExpenseCategory]
    BILLS: _ClassVar[ExpenseCategory]
    EDUCATION: _ClassVar[ExpenseCategory]
    HEALTH: _ClassVar[ExpenseCategory]
    OTHER: _ClassVar[ExpenseCategory]
UNKNOWN: ExpenseCategory
FOOD: ExpenseCategory
TRANSPORT: ExpenseCategory
SHOPPING: ExpenseCategory
ENTERTAINMENT: ExpenseCategory
BILLS: ExpenseCategory
EDUCATION: ExpenseCategory
HEALTH: ExpenseCategory
OTHER: ExpenseCategory

class CreateExpenseRequest(_message.Message):
    __slots__ = ("expense",)
    EXPENSE_FIELD_NUMBER: _ClassVar[int]
    expense: Expense
    def __init__(self, expense: _Optional[_Union[Expense, _Mapping]] = ...) -> None: ...

class CreateExpenseResponse(_message.Message):
    __slots__ = ("id", "return_msg")
    ID_FIELD_NUMBER: _ClassVar[int]
    RETURN_MSG_FIELD_NUMBER: _ClassVar[int]
    id: int
    return_msg: ReturnMsg
    def __init__(self, id: _Optional[int] = ..., return_msg: _Optional[_Union[ReturnMsg, _Mapping]] = ...) -> None: ...

class GetExpenseRequest(_message.Message):
    __slots__ = ("id",)
    ID_FIELD_NUMBER: _ClassVar[int]
    id: int
    def __init__(self, id: _Optional[int] = ...) -> None: ...

class GetExpenseResponse(_message.Message):
    __slots__ = ("expense", "return_msg")
    EXPENSE_FIELD_NUMBER: _ClassVar[int]
    RETURN_MSG_FIELD_NUMBER: _ClassVar[int]
    expense: Expense
    return_msg: ReturnMsg
    def __init__(self, expense: _Optional[_Union[Expense, _Mapping]] = ..., return_msg: _Optional[_Union[ReturnMsg, _Mapping]] = ...) -> None: ...

class ListExpensesRequest(_message.Message):
    __slots__ = ("date",)
    DATE_FIELD_NUMBER: _ClassVar[int]
    date: str
    def __init__(self, date: _Optional[str] = ...) -> None: ...

class Expense(_message.Message):
    __slots__ = ("id", "title", "amount", "category", "date")
    ID_FIELD_NUMBER: _ClassVar[int]
    TITLE_FIELD_NUMBER: _ClassVar[int]
    AMOUNT_FIELD_NUMBER: _ClassVar[int]
    CATEGORY_FIELD_NUMBER: _ClassVar[int]
    DATE_FIELD_NUMBER: _ClassVar[int]
    id: int
    title: str
    amount: float
    category: ExpenseCategory
    date: str
    def __init__(self, id: _Optional[int] = ..., title: _Optional[str] = ..., amount: _Optional[float] = ..., category: _Optional[_Union[ExpenseCategory, str]] = ..., date: _Optional[str] = ...) -> None: ...

class ReturnMsg(_message.Message):
    __slots__ = ("code", "msg")
    CODE_FIELD_NUMBER: _ClassVar[int]
    MSG_FIELD_NUMBER: _ClassVar[int]
    code: int
    msg: str
    def __init__(self, code: _Optional[int] = ..., msg: _Optional[str] = ...) -> None: ...

class ListExpensesResponse(_message.Message):
    __slots__ = ("expenses",)
    EXPENSES_FIELD_NUMBER: _ClassVar[int]
    expenses: _containers.RepeatedCompositeFieldContainer[Expense]
    def __init__(self, expenses: _Optional[_Iterable[_Union[Expense, _Mapping]]] = ...) -> None: ...

class UpdateExpenseRequest(_message.Message):
    __slots__ = ("expense",)
    EXPENSE_FIELD_NUMBER: _ClassVar[int]
    expense: Expense
    def __init__(self, expense: _Optional[_Union[Expense, _Mapping]] = ...) -> None: ...

class UpdateExpenseResponse(_message.Message):
    __slots__ = ("id", "return_msg")
    ID_FIELD_NUMBER: _ClassVar[int]
    RETURN_MSG_FIELD_NUMBER: _ClassVar[int]
    id: int
    return_msg: ReturnMsg
    def __init__(self, id: _Optional[int] = ..., return_msg: _Optional[_Union[ReturnMsg, _Mapping]] = ...) -> None: ...

class DeleteExpenseRequest(_message.Message):
    __slots__ = ("id",)
    ID_FIELD_NUMBER: _ClassVar[int]
    id: int
    def __init__(self, id: _Optional[int] = ...) -> None: ...

class DeleteExpenseResponse(_message.Message):
    __slots__ = ("id", "return_msg")
    ID_FIELD_NUMBER: _ClassVar[int]
    RETURN_MSG_FIELD_NUMBER: _ClassVar[int]
    id: int
    return_msg: ReturnMsg
    def __init__(self, id: _Optional[int] = ..., return_msg: _Optional[_Union[ReturnMsg, _Mapping]] = ...) -> None: ...
