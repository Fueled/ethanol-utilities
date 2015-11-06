//
//  ETHUtils.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 5/12/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "tgmath.h"

#define _ETH_TO_STRING(s) #s
#define ETH_TO_STRING(s) _ETH_TO_STRING(s)

#define ETH_CLASS_TO_NSSTRING(theClass) ({ (void)[(theClass) class]; ETH_TO_NSSTRING(theClass); })
#define ETH_PROTOCOL_TO_NSSTRING(theProtocol) ({ (void)@protocol(theProtocol); ETH_TO_NSSTRING(theProtocol); })

#define _ETH_TO_NSSTRING_(s) @#s
#define ETH_TO_NSSTRING(s) _ETH_TO_NSSTRING_(s)

#define ETHCALL(block, ...) \
  do { \
    if(block != nil) { \
      block(__VA_ARGS__); \
    } \
  } while(0)

#define _ETH_PROPERTY_POLICY_HELPER_copy_atomic OBJC_ASSOCIATION_COPY
#define _ETH_PROPERTY_POLICY_HELPER_copy_nonatomic OBJC_ASSOCIATION_COPY_NONATOMIC
#define _ETH_PROPERTY_POLICY_HELPER_copy___(atomicity) _ETH_PROPERTY_POLICY_HELPER_copy_ ## atomicity
#define _ETH_PROPERTY_POLICY_HELPER_copy__(atomicity) _ETH_PROPERTY_POLICY_HELPER_copy___(atomicity)
#define _ETH_PROPERTY_POLICY_HELPER_copy_ _ETH_PROPERTY_POLICY_HELPER_copy__(ETH_DEFAULT_ATOMIC_MODE())

#define _ETH_PROPERTY_POLICY_HELPER_strong_atomic OBJC_ASSOCIATION_RETAIN
#define _ETH_PROPERTY_POLICY_HELPER_strong_nonatomic OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define _ETH_PROPERTY_POLICY_HELPER_strong___(atomicity) _ETH_PROPERTY_POLICY_HELPER_strong_ ## atomicity
#define _ETH_PROPERTY_POLICY_HELPER_strong__(atomicity) _ETH_PROPERTY_POLICY_HELPER_strong___(atomicity)
#define _ETH_PROPERTY_POLICY_HELPER_strong_ _ETH_PROPERTY_POLICY_HELPER_strong__(ETH_DEFAULT_ATOMIC_MODE())

#define _ETH_PROPERTY_POLICY_HELPER_assign_atomic OBJC_ASSOCIATION_ASSIGN
#define _ETH_PROPERTY_POLICY_HELPER_assign_nonatomic _ETH_PROPERTY_POLICY_HELPER_assign_atomic
#define _ETH_PROPERTY_POLICY_HELPER_assign___(atomicity) _ETH_PROPERTY_POLICY_HELPER_assign_ ## atomicity
#define _ETH_PROPERTY_POLICY_HELPER_assign__(atomicity) _ETH_PROPERTY_POLICY_HELPER_assign___(atomicity)
#define _ETH_PROPERTY_POLICY_HELPER_assign_ _ETH_PROPERTY_POLICY_HELPER_assign__(ETH_DEFAULT_ATOMIC_MODE())

#define _ETH_PROPERTY_POLICY_HELPER_weak_atomic OBJC_ASSOCIATION_ASSIGN
#define _ETH_PROPERTY_POLICY_HELPER_weak_nonatomic _ETH_PROPERTY_POLICY_HELPER_assign_atomic
#define _ETH_PROPERTY_POLICY_HELPER_weak___(atomicity) _ETH_PROPERTY_POLICY_HELPER_assign_ ## atomicity
#define _ETH_PROPERTY_POLICY_HELPER_weak__(atomicity) _ETH_PROPERTY_POLICY_HELPER_assign___(atomicity)
#define _ETH_PROPERTY_POLICY_HELPER_weak_ _ETH_PROPERTY_POLICY_HELPER_assign__(ETH_DEFAULT_ATOMIC_MODE())

#define _ETH_PROPERTY_POLICY_HELPER__atomic _ETH_PROPERTY_POLICY_HELPER_assign_atomic
#define _ETH_PROPERTY_POLICY_HELPER__nonatomic _ETH_PROPERTY_POLICY_HELPER_assign_nonatomic
#define _ETH_PROPERTY_POLICY_HELPER_(policy, atomicity) _ETH_PROPERTY_POLICY_HELPER_ ## policy ## _ ## atomicity
#define _ETH_PROPERTY_POLICY_HELPER(policy, atomicity) _ETH_PROPERTY_POLICY_HELPER_(policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  static char firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key;

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter) \
static char firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key; \
- (type)firstLetterLowercase ## propertyNameWithoutFirstLetter ## Primitive { \
  return (getter)(objc_getAssociatedObject(self, &firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key)); \
}

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, setter) \
static char firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key; \
- (void)set ## firstLetterUppercase ## propertyNameWithoutFirstLetter ## Primitive:(type)value { \
  id idValue = (setter)(value); \
  objc_setAssociatedObject(self, &firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key, idValue, idValue != nil ? _ETH_PROPERTY_POLICY_HELPER(policy, atomicity) : _ETH_PROPERTY_POLICY_HELPER(assign, atomicity)); \
}

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY_(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER_(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
static char firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key; \
- (type)firstLetterLowercase ## propertyNameWithoutFirstLetter { \
  return [self firstLetterLowercase ## propertyNameWithoutFirstLetter ## Primitive]; \
}

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER_(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
static char firstLetterLowercase ## propertyNameWithoutFirstLetter ## Key; \
- (void)set ## firstLetterUppercase ## propertyNameWithoutFirstLetter:(type)value { \
  [self set ## firstLetterUppercase ## propertyNameWithoutFirstLetter ## Primitive:value]; \
}

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVEONLY_HELPER(macro, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  macro(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVEONLY_HELPER(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY_ ## primitiveOnly, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVEONLY_HELPER(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER_ ## primitiveOnly, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, setter, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVE_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, setter) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_PRIMITIVEONLY_HELPER(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER_ ## primitiveOnly, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, primitiveOnly) \

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, setter, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE_ALL(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_KEY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_GETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_IMPL_SETTER(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, setter, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE2(macro, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly) \
  macro(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE_ ## what, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, getter, setter, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_OBJECT(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, ^type(id value) { return value; }, ^id(id value) { return value; }, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_OBJECT_WEAK(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, ^type(id value) { return value; }, ^id(id value) { [((id)self.firstLetterLowercase ## propertyNameWithoutFirstLetter ## Primitive) performBlockOnDealloc:nil]; [((id)value) performBlockOnDealloc:^(id object) { self.firstLetterLowercase ## propertyNameWithoutFirstLetter = nil; }]; return value; }, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, copy, atomicity, ^type(id value) { return [value type ## Value]; }, ^id(type value) { return [NSValue valueWith ## type:value]; }, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, accessor, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_BASE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, copy, atomicity, ^type(id value) { return [value accessor ## Value]; }, ^id(type value) { return @(value); }, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CGPoint(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CGSize(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CGRect(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CGAffineTransform(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_UIEdgeInset(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_UIOffset(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_VALUE(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_NSTimeInterval(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, double, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CGFloat(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, double, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_NSInteger(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, integer, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_NSUInteger(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, integer, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_CLLocationDegrees(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, integer, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)
#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_BOOL(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_NUMBER(type, integer, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign2(macro, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly) \
  macro(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign_ ## type, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_weak(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_OBJECT_WEAK(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_copy(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_OBJECT(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_strong(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_OBJECT(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_assign(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly)

#define _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(macro, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly) \
  macro(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, what, primitiveOnly)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, ALL, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , ALL, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_READONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, GETTER, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_READONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , GETTER, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_WRITEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, SETTER, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_WRITEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , SETTER, )

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, ALL, PRIMITIVEONLY)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , ALL, PRIMITIVEONLY)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_READONLY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, GETTER, PRIMITIVEONLY)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_READONLY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , GETTER, PRIMITIVEONLY)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_WRITEONLY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, atomicity, SETTER, PRIMITIVEONLY)

#define ETH_SYNTHESIZE_CATEGORY_PROPERTY_WRITEONLY_PRIMITIVEONLY(type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy) \
  _ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY2(_ETH_SYNTHESIZE_CATEGORY_PROPERTY_ATOMICITY_ ## policy, type, firstLetterUppercase, firstLetterLowercase, propertyNameWithoutFirstLetter, policy, , SETTER, PRIMITIVEONLY)

#define ETH_NARG(...) \
  (_ETH_NARG(_0, ## __VA_ARGS__, _ETH_RSEQ_N()) - 1)
#define _ETH_NARG(...) \
  _ETH_ARG_N(__VA_ARGS__)
#define _ETH_ARG_N( \
  _1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
  _11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
  _21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
  _31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
  _41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
  _51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
  _61,_62,_63,N,...) N
#define _ETH_RSEQ_N() \
  63,62,61,60,                   \
  59,58,57,56,55,54,53,52,51,50, \
  49,48,47,46,45,44,43,42,41,40, \
  39,38,37,36,35,34,33,32,31,30, \
  29,28,27,26,25,24,23,22,21,20, \
  19,18,17,16,15,14,13,12,11,10, \
  9,8,7,6,5,4,3,2,1,0

#define ETH_INIT_METHOD __attribute__((objc_method_family(init)))
#define ETH_NEW_METHOD __attribute__((objc_method_family(new)))
#define ETH_COPY_METHOD __attribute__((objc_method_family(copy)))
#define ETH_MUTABLECOPY_METHOD __attribute__((objc_method_family(mutableCopy)))

#define ETH_SET_BIT(var, bit) ((var) | (1 << (bit)))
#define ETH_UNSET_BIT(var, bit) ((var) & ~(1 << (bit)))
#define ETH_HAS_BIT(var, bit) ((var) & (1 << (bit)))

#define ETH_GET_BIT_RANGE(var, position, length) (((var) >> ((position) * (length))) & ((1 << (length)) - 1))
#define ETH_BIT_RANGE(position, length, range) (((range) & ((1 << (length)) - 1)) << ((position) * (length)))
#define ETH_SET_BIT_RANGE(var, position, length, range) ((var) | ETH_BIT_RANGE(position, length, range))

#define ETH_COMPARE_WITH_DELTA(value, compareTo, delta) \
	({ \
		BOOL returnValue; \
		if(isinf(value) && isinf(compareTo)) { \
			if((value < 0.0 && compareTo > 0.0) || (!value > 0.0 && compareTo < 0.0)) { \
				returnValue = NO; \
			} else { \
				returnValue = !isinf(delta); \
			} \
		} else if(isinf(delta)) { \
			if(isinf(value)) { \
				returnValue = NO; \
			} else { \
				returnValue = YES; \
			} \
		} else { \
			returnValue = fabs(value - compareTo) < fabs(delta); \
		} \
		returnValue; \
	})
