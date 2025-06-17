from google.protobuf import timestamp_pb2 as _timestamp_pb2
from google.protobuf.internal import containers as _containers
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from collections.abc import Iterable as _Iterable, Mapping as _Mapping
from typing import ClassVar as _ClassVar, Optional as _Optional, Union as _Union

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
    __slots__ = ("id", "status")
    ID_FIELD_NUMBER: _ClassVar[int]
    STATUS_FIELD_NUMBER: _ClassVar[int]
    id: int
    status: SuccessStatus
    def __init__(self, id: _Optional[int] = ..., status: _Optional[_Union[SuccessStatus, _Mapping]] = ...) -> None: ...

class GetExpenseRequest(_message.Message):
    __slots__ = ("id",)
    ID_FIELD_NUMBER: _ClassVar[int]
    id: int
    def __init__(self, id: _Optional[int] = ...) -> None: ...

class GetExpenseResponse(_message.Message):
    __slots__ = ("expense", "status")
    EXPENSE_FIELD_NUMBER: _ClassVar[int]
    STATUS_FIELD_NUMBER: _ClassVar[int]
    expense: Expense
    status: SuccessStatus
    def __init__(self, expense: _Optional[_Union[Expense, _Mapping]] = ..., status: _Optional[_Union[SuccessStatus, _Mapping]] = ...) -> None: ...

class ListExpensesRequest(_message.Message):
    __slots__ = ("date",)
    DATE_FIELD_NUMBER: _ClassVar[int]
    date: _timestamp_pb2.Timestamp
    def __init__(self, date: _Optional[_Union[datetime.datetime, _timestamp_pb2.Timestamp, _Mapping]] = ...) -> None: ...

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
    date: _timestamp_pb2.Timestamp
    def __init__(self, id: _Optional[int] = ..., title: _Optional[str] = ..., amount: _Optional[float] = ..., category: _Optional[_Union[ExpenseCategory, str]] = ..., date: _Optional[_Union[datetime.datetime, _timestamp_pb2.Timestamp, _Mapping]] = ...) -> None: ...

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
    __slots__ = ("id", "status")
    ID_FIELD_NUMBER: _ClassVar[int]
    STATUS_FIELD_NUMBER: _ClassVar[int]
    id: int
    status: SuccessStatus
    def __init__(self, id: _Optional[int] = ..., status: _Optional[_Union[SuccessStatus, _Mapping]] = ...) -> None: ...

class DeleteExpenseRequest(_message.Message):
    __slots__ = ("id",)
    ID_FIELD_NUMBER: _ClassVar[int]
    id: int
    def __init__(self, id: _Optional[int] = ...) -> None: ...

class DeleteExpenseResponse(_message.Message):
    __slots__ = ("id", "status")
    ID_FIELD_NUMBER: _ClassVar[int]
    STATUS_FIELD_NUMBER: _ClassVar[int]
    id: int
    status: SuccessStatus
    def __init__(self, id: _Optional[int] = ..., status: _Optional[_Union[SuccessStatus, _Mapping]] = ...) -> None: ...

class SuccessStatus(_message.Message):
    __slots__ = ("code", "msg")
    CODE_FIELD_NUMBER: _ClassVar[int]
    MSG_FIELD_NUMBER: _ClassVar[int]
    code: int
    msg: str
    def __init__(self, code: _Optional[int] = ..., msg: _Optional[str] = ...) -> None: ...
